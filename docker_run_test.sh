# # Run the container with GPU passthrough
# docker run --rm -it \
#   --device=/dev/dri/card1 \  # Pass the iGPU device
#   --env VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json \
#   sd_vulkan


### Testing with loccal-models


docker run -it --device=/dev/dri/card1 --env VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json -v /home/pyro/sd-inferance/models:/models --entrypoint /bin/bash sd_vulkan



./sd -m /models/sd-v1-4.ckpt -s 242 -v --color -p "Picture of a cute puppy"