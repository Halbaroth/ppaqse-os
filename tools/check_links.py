#!/usr/bin/env python3
import argparse, re, requests, sys

def main(file: str, timeout: float):
  with open(file, 'r') as file:
    for line in file:
      for x in re.finditer(r"url = \"([^\"]*)\"", line):
        url = x.group(1)
        try:
          req = requests.head(url, allow_redirects=True, timeout=timeout)
          match req.status_code:
            case 200: pass
            case status:
              print(f"{url}: {status}")
        except requests.ConnectionError:
          print(f"{url}: error")
        except requests.Timeout:
          print(f"{url}: timeout")

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Check url in bibtex files")
  parser.add_argument("file", help="Path to the bibtex file")
  parser.add_argument(
    "-t", "--timeout",
    type=float,
    default=1.0,
    help="Timeout in seconds")
  args = parser.parse_args()
  main(file=args.file, timeout=args.timeout)
