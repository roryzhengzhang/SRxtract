# Speaker Recognition extraction tool (SRxtract)
This repository contains a Scripts to extract speaker embeddings.

## Installation

### If you are planning to run this on SimCloud no installation is required.

Fork and clone this repository in your folder:
```shell
$ git clone <url_of_this_repository> /path/to/your/SRxtract
```

Just run the following to obtain a SimCloud interactive session:
```shell
$ ./run_simcloud_intercative.sh
```

### If you are on the BFG no installation is required (will be deprecated soon).
Using my environment (path.sh and job_config.sh) should be sufficient to succesfully run it.


## Usage for SimCloud

### Documentation
Once you have obtained a SimCloud session run:
```shell
$ cd /bundle
$ ./run.sh
```

The output is stored in:
```shell
$ /bundle/spk_emb.h5
```

There is no thorough documentation yet but the usage is really straightforward.


## Usage for BFG (will be deprecated soon).

### Documentation

Fork and clone this repository in your folder:
```shell
$ git clone <url_of_this_repository> /path/to/your/SRxtract
```
Run it:
```shell
$ cd /pat/to/your/SRxtract
$ ./run_extract.sh <your_scp_file.scp>
```

The output is stored in:
```shell
$ output/<your_scp_file>/sv.scp
```

There is no thorough documentation yet but the usage is really straightforward.

### Data preparation steps (optional):

1. The tool expects audio files to have 16kHz sampling, 16-bit signed integer PCM encoding. Here is a simple helper to convert original audio files to the required format:
```shell
$ ./run_convert.sh <original_audio_path> <output_converted_path>
```
2. The tool only needs one input: your_scp_file.scp. This can be created with the following:
```shell
$ ./run_create_scp.sh <output_converted_path> <your_scp_file.scp>
```

### Parallelisation (optional):
In the case the <your_scp_file.scp> contains more than 500 elements, the tool can be run as a job array in BFG. For this simply set nj in extract_sv.sh


