import re
import sys
import subprocess


def get_prev_gittag(target_tag: str) -> str:
    result = subprocess.run(
        ["git", "tag"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )
    if result.returncode == 0:
        tags = result.stdout.strip().split("\n")
        loc = tags.index(target_tag) - 1
        if loc < 0:
            return None
        while True:
            prev_tag = tags[loc] if len(tags) > 1 else ""
            if "rc" not in prev_tag:
                break
            loc -= 1
        return prev_tag
    else:
        raise subprocess.CalledProcessError(
            result.returncode, result.args, result.stderr
        )


def extract_package_version(document: str, package_name: str):
    pattern = rf"{re.escape(package_name)} (v[^\s]+)"
    match = re.search(pattern, document)
    if match:
        return match.group(1)
    else:
        raise ValueError(f"Package {package_name} not found in the document.")


def extract_go_version(document: str):
    pattern = r"go ([^\s]+)"
    match = re.search(pattern, document)
    if match:
        return match.group(1)
    else:
        return None


with open("go.mod", "r") as file:
    gomod = file.read()

args = sys.argv[1:]
if len(args) != 1:
    raise ValueError("Invalid number of arguments. Please provide the release version.")

# Generate release note
TAG = args[0]
PREV_TAG = get_prev_gittag(TAG)
GO_VERSION = extract_go_version(gomod)
OSTRACON_VERSION = extract_package_version(gomod, "github.com/Finschia/ostracon")
FNSASDK_VERSION = extract_package_version(gomod, "github.com/Finschia/finschia-sdk")
WASMD_VERSION = extract_package_version(gomod, "github.com/Finschia/wasmd")
IBC_VERSION = extract_package_version(gomod, "github.com/cosmos/ibc-go/v4")


def extract_release_contents(target: str, cur_tag: str, prev_tag: str) -> str:
    with open(target, "r") as file:
        document = file.read()
    start_marker = f"## [{cur_tag}]"
    start_pos = document.find(start_marker) + len(start_marker) + len(" - YYYY-MM-DD")
    if start_pos != -1:
        if prev_tag is None:
            end_pos = document.find("<!-- Release links -->")
            if end_pos == -1:
                match = re.search(r"## \[v\d+\.\d+\.\d+] - \d{4}-\d{2}-\d{2}", document[start_pos:])
                if match is None:
                    end_pos = -1
                else:
                    end_pos = start_pos + match.start() - 1
        else:
            end_marker = f"## [{prev_tag}]"
            end_pos = document.find(end_marker)
            if end_pos == -1:
                match = re.search(r"## \[v\d+\.\d+\.\d+] - \d{4}-\d{2}-\d{2}", document[start_pos:])
                end_pos = start_pos + match.start() - 1
    else:
        raise ValueError("Content not found between the specified markers.")
    return document[start_pos:end_pos].strip()


release_note = f"""# Finschia {TAG} Release Note

{extract_release_contents("RELEASE_DESCR.md", TAG, PREV_TAG)}

## What's Changed
Check out all the changes [here](https://github.com/Finschia/finschia/compare/{PREV_TAG or ""}...{TAG})

{extract_release_contents("RELEASE_CHANGELOG.md", TAG, PREV_TAG)}

## Base sub modules
* Ostracon: [{OSTRACON_VERSION}](https://github.com/Finschia/ostracon/tree/{OSTRACON_VERSION})
* Finschia-sdk: [{FNSASDK_VERSION}](https://github.com/Finschia/finschia-sdk/tree/{FNSASDK_VERSION})
* Finschia/wasmd: [{WASMD_VERSION}](https://github.com/Finschia/wasmd/tree/{WASMD_VERSION})
* Finschia/ibc-go: [{IBC_VERSION}](https://github.com/Finschia/ibc-go/tree/{IBC_VERSION})

## Build from source
You must use Go {GO_VERSION} if building from source
```shell
git clone https://github.com/Finschia/finschia
cd finschia && git checkout {TAG}
make install
```

## Run with Docker
If you want to run fnsad in a Docker container, you can use the Docker images.
* docker image: `finschia/finschianode:{TAG[1:]}`
```shell
docker run finschia/finschianode:{TAG[1:]} fnsad version
# {TAG[1:]}
```

## Download binaries

Binaries for linux and darwin are available below.\n"""

with open("RELEASE_NOTE.md", "w") as file:
    file.write(release_note)
