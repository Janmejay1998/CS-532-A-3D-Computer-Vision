import numpy as np
from PIL import Image

# Defining the image warping function
def Warping_image(original, new, H):
    (h,b,_) = new.shape
    for i in range(0,b):
        for j in range(0,h):
            co_ordinates = [i,j,1]
            result = np.matmul(H, co_ordinates)
            # Changing the homogeneous co_ordinates back to regular inhomogeneous co_ordinates
            x = result[0]/result[2]
            y = result[1]/result[2]
            split_x = str(x).split('.')
            split_y = str(y).split('.')
            get_i = int(split_y[0])
            get_j = int(split_x[0])
            float_i = float('0.'+split_y[1])
            float_j = float('0.'+split_x[1])
            if(float_i+float_j <= 0.01):
                new[j][i] = original[get_i][get_j]
            else:
                rgb_values = [0,0,0]
                for k in range(0,3):
                    result = (1-float_i)*(1-float_j)*original[get_i][get_j][k] + (float_i)*(1-float_j)*original[get_i+1][get_j][k] \
                    + (float_i)*(float_j)*original[get_i+1][get_j-1][k] + (1-float_i)*(float_j)*original[get_i][get_j-1][k]
                    rgb_values[k] = int(result)
                new[j][i] = rgb_values
    new_img = Image.fromarray(new)
    return new_img

# Defining The Normalize Function
def normalize(breadth,height):
    Normalize = np.array([[breadth+height,0,breadth/2],[0,breadth+height,height/2],[0,0,1]])
    La = np.linalg.inv(Normalize)
    return La

# Defining the matrix computation function
def compute_matrix(origin, destination):
    [a,b,c] = origin
    [x,y,z] = destination
    matrix_1 = np.array([[0,0,0,-a,-b,-c,y*a,y*b,y*c],[a,b,c,0,0,0,-x*a,-x*b,-x*c]])
    return matrix_1

image = Image.open("basketball-court.ppm")
new_img = Image.new(mode = "RGB", size = (940, 500))

array_1 = [[23,193,1],[247,51,1],[402,74,1],[279,279,1]]
array_2 = [[0,0,1],[939,0,1],[939,499,1],[0,499,1]]
Top1 = normalize(488,366)
Top2 = normalize(940,500)

# Normalizing both arrays, array_1 and array_2
for i in range(0,4):
    array_1[i] = np.matmul(Top1,array_1[i])
    array_2[i] = np.matmul(Top2,array_2[i])

# Computing and generating the matrix_1
m1 = np.zeros((8,9))
for i in range(0,4):
    cm = compute_matrix(array_1[i],array_2[i])
    iterate = 2*i
    m1[iterate:iterate+2] = cm
    ++i

# Calculating and evaluating the svd and taking least eigenvector
Up, Down, Eigenvector = np.linalg.svd(m1)
Hm = Eigenvector[8]

# Reshaping into 3*3 homography matrix
Hr = np.reshape(Hm,(3,3))

# Denormalizing the Hr component
Hd = np.matmul(np.matmul(np.linalg.pinv(Top2),Hr),Top1)

# Now taking the homography matrix inverse because all the implementation are in reverse warping
Hla = np.linalg.inv(Hd)

new_img = Warping_image(np.array(image),np.array(new_img),Hla)
new_img.save("New_Basketball_Court_Image.jpg")
new_img.show()
