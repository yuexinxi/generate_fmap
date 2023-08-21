# generate_fmap
A fieldmap generating tool that takes magnitude and phase images to produce a fmap file

## Usage
The scripts uses Synthstrip and FSL tools to generate fieldmaps from one of the following situation:
1. 2 phase images and 2 magnitude images (./dualecho_fieldmap.sh)
2. 1 phasediff image and 2 magnitude images (./phasediff_fieldmap.sh)

It will create another directory with the same data but replace above images with fieldmap files in BIDS specification.

## Docker command
Situation 1: 
`docker run -v <path/to/input/folder>:/data -v <path/to/output/folder>:/out generate_fmap ./dualecho_fieldmap.sh --mag1=</data/relative/path/to/magnitude1> --mag2=</data/relative/path/to/magnitude2> --phs1=</data/relative/path/to/phase1> --phs2=</data/relative/path/to/phase2>`

Situation 2:
`docker run -v <path/to/input/folder>:/data -v <path/to/output/folder>:/out generate_fmap ./phasediff_fieldmap.sh --mag1=</data/relative/path/to/magnitude1> --mag2=</data/relative/path/to/magnitude2> --phs=</data/relative/path/to/phasediff>`

Optional arguments:

    --dte   : delta TE                  ( default: 3.75 ms )  

## Example:
```
docker run --rm -it -v $PWD/MY_BIDS:/data -v $PWD/MY_BIDS2:/out generate_fmap ./dualecho_fieldmap.sh --mag1=/data/sub-03/fmap/sub-03_acq-MEGRE_magnitude1.nii.gz --mag2=/data/sub-03/fmap/sub-03_acq-MEGRE_magnitude2.nii.gz --phs1=/data/sub-03/fmap/sub-03_acq-MEGRE_phase1.nii.gz --phs2=/data/sub-03/fmap/sub-03_acq-MEGRE_phase2.nii.gz --dte=2.75
```

