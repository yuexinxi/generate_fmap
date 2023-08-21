# FROM ubuntu:focal-20230801

# Build from base image synthstrip
# FROM freesurfer/synthstrip:latest
# Install jq
#RUN apt-get update && \
#    apt-get install -y jq

#COPY fslinstaller.py /tmp/
#COPY . /home/
#RUN python3 /tmp/fslinstaller.py - -d /opt/fsl-6.0.6.5 -V 6.0.6.5

#ENTRYPOINT [""]
#CMD ["/bin/bash"]

# Install FSL
FROM ubuntu:focal-20230801
ENV FSLDIR="/opt/fsl-6.0.6.5" \
    PATH="/opt/fsl-6.0.6.5/bin:$PATH" \
    FSLOUTPUTTYPE="NIFTI_GZ" \
    FSLMULTIFILEQUIT="TRUE" \
    FSLTCLSH="/opt/fsl-6.0.6.5/bin/fsltclsh" \
    FSLWISH="/opt/fsl-6.0.6.5/bin/fslwish" \
    FSLLOCKDIR="" \
    FSLMACHINELIST="" \
    FSLREMOTECALL="" \
    FSLGECUDAQ="cuda.q"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           ca-certificates \
           curl \
           dc \
           file \
           libfontconfig1 \
           libfreetype6 \
           libgl1-mesa-dev \
           libgl1-mesa-dri \
           libglu1-mesa-dev \
           libgomp1 \
           libice6 \
           libopenblas-base \
           libxcursor1 \
           libxft2 \
           libxinerama1 \
           libxrandr2 \
           libxrender1 \
           libxt6 \
           nano \
           python3 \
           sudo \
           wget \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Installing FSL ..." \
    && curl -fsSL https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/fslinstaller.py | python3 - -d /opt/fsl-6.0.6.5 -V 6.0.6.5

# Install Freesurfer
ENV OS="Linux" \
    PATH="/opt/freesurfer-7.3.1/bin:/opt/freesurfer-7.3.1/fsfast/bin:/opt/freesurfer-7.3.1/tktools:/opt/freesurfer-7.3.1/mni/bin:$PATH" \
    FREESURFER_HOME="/opt/freesurfer-7.3.1" \
    FREESURFER="/opt/freesurfer-7.3.1" \
    SUBJECTS_DIR="/opt/freesurfer-7.3.1/subjects" \
    LOCAL_DIR="/opt/freesurfer-7.3.1/local" \
    FSFAST_HOME="/opt/freesurfer-7.3.1/fsfast" \
    FMRI_ANALYSIS_DIR="/opt/freesurfer-7.3.1/fsfast" \
    FUNCTIONALS_DIR="/opt/freesurfer-7.3.1/sessions" \
    FS_OVERRIDE="0" \
    FIX_VERTEX_AREA="" \
    FSF_OUTPUT_FORMAT="nii.gz# mni env requirements" \
    MINC_BIN_DIR="/opt/freesurfer-7.3.1/mni/bin" \
    MINC_LIB_DIR="/opt/freesurfer-7.3.1/mni/lib" \
    MNI_DIR="/opt/freesurfer-7.3.1/mni" \
    MNI_DATAPATH="/opt/freesurfer-7.3.1/mni/data" \
    MNI_PERL5LIB="/opt/freesurfer-7.3.1/mni/share/perl5" \
    PERL5LIB="/opt/freesurfer-7.3.1/mni/share/perl5"
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           bc \
           ca-certificates \
           curl \
           libgomp1 \
           libxmu6 \
           libxt6 \
           perl \
           tcsh \
    && rm -rf /var/lib/apt/lists/* \
    && echo "Downloading FreeSurfer ..." \
    && mkdir -p /opt/freesurfer-7.3.1 \
    && curl -fL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.1/freesurfer-linux-centos7_x86_64-7.3.1.tar.gz \
    | tar -xz -C /opt/freesurfer-7.3.1 --owner root --group root --no-same-owner --strip-components 1 \
         --exclude='average/mult-comp-cor' \
         --exclude='lib/cuda' \
         --exclude='lib/qt' \
         --exclude='subjects/V1_average' \
         --exclude='subjects/bert' \
         --exclude='subjects/cvs_avg35' \
         --exclude='subjects/cvs_avg35_inMNI152' \
         --exclude='subjects/fsaverage3' \
         --exclude='subjects/fsaverage4' \
         --exclude='subjects/fsaverage5' \
         --exclude='subjects/fsaverage6' \
         --exclude='subjects/fsaverage_sym' \
         --exclude='trctrain'
RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends \
           ca-certificates \
           curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL --output /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
    && chmod +x /usr/local/bin/jq

# Copy scripts in home
COPY . /home/

# Save specification to JSON.
RUN printf '{ \
  "pkg_manager": "apt", \
  "existing_users": [ \
    "root" \
  ], \
  "instructions": [ \
    { \
      "name": "from_", \
      "kwds": { \
        "base_image": "ubuntu:focal-20230801" \
      } \
    }, \
    { \
      "name": "env", \
      "kwds": { \
        "FSLDIR": "/opt/fsl-6.0.6.5", \
        "PATH": "/opt/fsl-6.0.6.5/bin:$PATH", \
        "FSLOUTPUTTYPE": "NIFTI_GZ", \
        "FSLMULTIFILEQUIT": "TRUE", \
        "FSLTCLSH": "/opt/fsl-6.0.6.5/bin/fsltclsh", \
        "FSLWISH": "/opt/fsl-6.0.6.5/bin/fslwish", \
        "FSLLOCKDIR": "", \
        "FSLMACHINELIST": "", \
        "FSLREMOTECALL": "", \
        "FSLGECUDAQ": "cuda.q" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    bc \\\\\\n    ca-certificates \\\\\\n    curl \\\\\\n    dc \\\\\\n    file \\\\\\n    libfontconfig1 \\\\\\n    libfreetype6 \\\\\\n    libgl1-mesa-dev \\\\\\n    libgl1-mesa-dri \\\\\\n    libglu1-mesa-dev \\\\\\n    libgomp1 \\\\\\n    libice6 \\\\\\n    libopenblas-base \\\\\\n    libxcursor1 \\\\\\n    libxft2 \\\\\\n    libxinerama1 \\\\\\n    libxrandr2 \\\\\\n    libxrender1 \\\\\\n    libxt6 \\\\\\n    nano \\\\\\n    python3 \\\\\\n    sudo \\\\\\n    wget\\nrm -rf /var/lib/apt/lists/*\\n\\necho \\"Installing FSL ...\\"\\ncurl -fsSL https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/fslinstaller.py | python3 - -d /opt/fsl-6.0.6.5 -V 6.0.6.5" \
      } \
    }, \
    { \
      "name": "env", \
      "kwds": { \
        "OS": "Linux", \
        "PATH": "/opt/freesurfer-7.3.1/bin:/opt/freesurfer-7.3.1/fsfast/bin:/opt/freesurfer-7.3.1/tktools:/opt/freesurfer-7.3.1/mni/bin:$PATH", \
        "FREESURFER_HOME": "/opt/freesurfer-7.3.1", \
        "FREESURFER": "/opt/freesurfer-7.3.1", \
        "SUBJECTS_DIR": "/opt/freesurfer-7.3.1/subjects", \
        "LOCAL_DIR": "/opt/freesurfer-7.3.1/local", \
        "FSFAST_HOME": "/opt/freesurfer-7.3.1/fsfast", \
        "FMRI_ANALYSIS_DIR": "/opt/freesurfer-7.3.1/fsfast", \
        "FUNCTIONALS_DIR": "/opt/freesurfer-7.3.1/sessions", \
        "FS_OVERRIDE": "0", \
        "FIX_VERTEX_AREA": "", \
        "FSF_OUTPUT_FORMAT": "nii.gz# mni env requirements", \
        "MINC_BIN_DIR": "/opt/freesurfer-7.3.1/mni/bin", \
        "MINC_LIB_DIR": "/opt/freesurfer-7.3.1/mni/lib", \
        "MNI_DIR": "/opt/freesurfer-7.3.1/mni", \
        "MNI_DATAPATH": "/opt/freesurfer-7.3.1/mni/data", \
        "MNI_PERL5LIB": "/opt/freesurfer-7.3.1/mni/share/perl5", \
        "PERL5LIB": "/opt/freesurfer-7.3.1/mni/share/perl5" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    bc \\\\\\n    ca-certificates \\\\\\n    curl \\\\\\n    libgomp1 \\\\\\n    libxmu6 \\\\\\n    libxt6 \\\\\\n    perl \\\\\\n    tcsh\\nrm -rf /var/lib/apt/lists/*\\necho \\"Downloading FreeSurfer ...\\"\\nmkdir -p /opt/freesurfer-7.3.1\\ncurl -fL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.1/freesurfer-linux-centos7_x86_64-7.3.1.tar.gz \\\\\\n| tar -xz -C /opt/freesurfer-7.3.1 --owner root --group root --no-same-owner --strip-components 1 \\\\\\n  --exclude='"'"'average/mult-comp-cor'"'"' \\\\\\n  --exclude='"'"'lib/cuda'"'"' \\\\\\n  --exclude='"'"'lib/qt'"'"' \\\\\\n  --exclude='"'"'subjects/V1_average'"'"' \\\\\\n  --exclude='"'"'subjects/bert'"'"' \\\\\\n  --exclude='"'"'subjects/cvs_avg35'"'"' \\\\\\n  --exclude='"'"'subjects/cvs_avg35_inMNI152'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage3'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage4'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage5'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage6'"'"' \\\\\\n  --exclude='"'"'subjects/fsaverage_sym'"'"' \\\\\\n  --exclude='"'"'trctrain'"'"'" \
      } \
    }, \
    { \
      "name": "run", \
      "kwds": { \
        "command": "apt-get update -qq\\napt-get install -y -q --no-install-recommends \\\\\\n    ca-certificates \\\\\\n    curl\\nrm -rf /var/lib/apt/lists/*\\ncurl -fsSL --output /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64\\nchmod +x /usr/local/bin/jq" \
      } \
    } \
  ] \
}' > /.reproenv.json
# End saving to specification to JSON.

# Save /home/generate_fmap in /bashrc
RUN echo "export PATH=$PATH:/home/generate_fmap" >> ~/.bashrc

WORKDIR /home/generate_fmap/