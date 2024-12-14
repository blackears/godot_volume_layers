import numpy as np
import opensimplex
from PIL import Image

feature_size = 10
size_x = 70
size_y = 60
size_z = 50
size_w = 60

#opensimplex.seed(13)
#opensimplex.random_seed()

#ix, iy = rng.random(2), rng.random(2)
ix = np.arange(0, feature_size, feature_size / size_x)
iy = np.arange(0, feature_size, feature_size / size_y)
iz = np.arange(0, feature_size, feature_size / size_z)
iw = np.arange(0, feature_size, feature_size / size_w)

#print(ix, iy)

arr = opensimplex.noise4array(ix, iy, iz, iw)
arr = (arr + 1) * .5

print("Noise volume calculated")

# im_data = (arr[:, :, 0, 0] * 255).astype(np.uint8)

# print(im_data)

# im = Image.fromarray(im_data)
# im.save("noise.png")

np.save('noise_data_4d.npy', arr.astype(np.float16))

