# vt-batch
vt-batch is a Mac OS utility written in Objective-C that queries Virus Total API by providing a text file with hashes.

- Regular expression checks if the text file contains hashes (MD5, SHA1 and SHA256).
- If the request is a valid hash it will be sent to Virus Total API.
- The results will be saved in the `results` directory with the hash value as the filename in JSON extension.
- The API key must be provided during the execution of the binary.

Sample text file:
```
46b313cb4f205357cee65a2c881aa7db
dea154a933570b6d4613fd562af03343e0267a43512151c698ccf3e105eb02b9
4a6c819149fa1b431b09140570a686e6c8b9ab04
```

Usage: vt-batch <filepath> <apikey>

```
./vt-batch hashes.txt abcdef123456
2023-01-13 23:01:31.585 vt-batch[48883:2540638] JSON saved to file: /Users/meeseeks/results/46b313cb4f205357cee65a2c881aa7db.json
2023-01-13 23:01:33.090 vt-batch[48883:2540638] JSON saved to file: /Users/meeseeks/results/dea154a933570b6d4613fd562af03343e0267a43512151c698ccf3e105eb02b9.json
2023-01-13 23:01:34.665 vt-batch[48883:2540638] JSON saved to file: /Users/meeseeks/results/4a6c819149fa1b431b09140570a686e6c8b9ab04.json
```
