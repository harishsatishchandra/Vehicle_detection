# Vehicle detection and classification

As the number vehicles on road increases, it is getting increasingly harder to manage traffic. Vehicle classification plays a vital role in order to manage the ever increasing amount of traffic. Electronic toll collection for instance, allows vehicles to travel at normal speed during the toll payment, which helps to avoid the traffic delay at toll collection points. One of the major components of an electronic toll collection is the Automatic Vehicle Detection and Classification (AVDC) system which is important to classify the vehicle so that the toll is charged according to the vehicle classes. We approach the problem of vehicle detection and classification by using Covariance matrices as feature descriptors for different vehicles. The result of this is shown in the following animation. The video feed is taken from a camera pointed towards the I-90 inter state highway.

![video_gif](https://user-images.githubusercontent.com/19624843/63905108-29587b80-c9e1-11e9-8ad7-265265b1a8a4.gif)

## 1 Vehicle Detection
The images being used for this project are obtained from two separate web cams (AXIS 207W Network Camera) placed in different rooms and at different viewing angles overlooking a freeway with a variety of vehicle traffic. The images were taken during a relatively low traffic period to minimize ghosting effects and overlapping vehicles and in most occasions the ambient light present was low enough to not cause excess glare or amplify the dirt on the windows. The camera produced jpeg images with a resolution of 480×640 at a frame rate of around 30 frames per second. Snapshots of the video feed were taken during different number of vehicles passing by, so that a diverse set of 20 images were obtained. A typical image obtained from the web cam is shown in fig. 1

![fig1](https://user-images.githubusercontent.com/19624843/63905867-a5ec5980-c9e3-11e9-9590-9a8acaf73e29.jpg)

## 2 Background Subtraction
Background subtraction is used to remove the information that does not pertain to the objects of interest in the image. Background subtraction is a widely used approach for detecting moving objects in videos from static cameras. We implement background subtraction on the grayscale version of the color image obtained from the web cams, by taking the weighted sum of the color channels, according to equation 1, where the coefficients are obtained from the luminosity function of the CIE standard observer. 

![eqn1](https://user-images.githubusercontent.com/19624843/63905881-b00e5800-c9e3-11e9-8d62-2f1a28f84c4d.JPG)

The rationale in the approach is that of detecting the moving objects from the difference between the current frame and a reference frame. Here, we obtain the reference frame by taking the average image from the set of images, according to equation 2. the background subtracted image is obtained according to equation 3. The reference frame for our image set and a background subtracted image is shown in fig 2 and 3. 

![eqn2](https://user-images.githubusercontent.com/19624843/63905890-b7356600-c9e3-11e9-9fa7-cea24f4fa565.JPG)

![fig3](https://user-images.githubusercontent.com/19624843/63905894-bef50a80-c9e3-11e9-8a95-fd498f036dc5.jpg)

![fig4](https://user-images.githubusercontent.com/19624843/63905897-c1effb00-c9e3-11e9-99c8-5576bcb8fa1f.jpg)

## 3 Noise Reduction
The images obtained from the web cam is generally noisy, either because of dust on the windows or from noisy compression. We use a 5x5 median filter to filter out such noise. We chose the median filter for its edge preserving properties. We use a Matlab function for the median filter, which basically creates a window of given size and sorts all the values in the window in ascending order, and chooses the center value in the sorted array. 

We then shift the image up by 20, so that we can filter out some of the high valued pixels, but keeping the pixels corresponding to the moving vehicles. This value of 20 was arrived at emperically, by changing pixel values with the aim of reducing unwanted noise, while keeping the pixel values related to moving vehicles. Note that this value is highly dependent on the amount of ambient light available at any given time. We then set all the negative valued pixels to 255, since the moving vehicles had the lowest luminance, and all positive valued pixels to 0, as shown in equation 4. This image is then converted to a binary image, as shown in fig 4. 

![eqn3](https://user-images.githubusercontent.com/19624843/63905951-e8159b00-c9e3-11e9-8892-21af8deb50d6.JPG)

![fig4](https://user-images.githubusercontent.com/19624843/63906101-7d189400-c9e4-11e9-986c-186fad531a30.jpg)

## 4 Markov Random Field (MRF) model for coherent results
The binary image shown in Figure 4 is connected enough for achieving good segmentation and classification. But, this is not always the case when there are large areas on a vehicle with large variations in intensity, such as a white colored bus with black windows. We found out that for such cases, our segmentation algorithm either identified one vehicle as two separate vehicles, or if the original vehicle was small enough, completely missed it altogether. In order to solve this problem, we decided to use the MRF model in order to fill in the gaps within the boundary of a vehicle. Figures 5 and 6 show the before and after using MRF model to close the gaps.

![fig5](https://user-images.githubusercontent.com/19624843/63905906-ca483600-c9e3-11e9-870e-b4c3362523e9.jpg)

![fig6](https://user-images.githubusercontent.com/19624843/63905921-d46a3480-c9e3-11e9-8f1e-2ea4899c8dca.png)

## 5 Image Segmentation
We scan the entire binary image to find all the contiguous groups of activated pixels. We use Matlab’s function ‘BWCONNCOMP’ from the image processing toolbox, with a 8-connected neighborhood to specify the connectivity for the connected components. This function first searches for an unlabeled pixel ‘x’. It then uses a flood-fill algorithm to label all the pixels in the connected component containing the pixel ‘x’. It then repeats the above steps until all the pixels are labeled. A bounding box is then drawn around all the connected groups with an area of above 2000px2. Fig. 5 and 6 shows detection of a single and multiple vehicles in an image. This entire process of vehicle detection takes about 6.3 secs. For running through an image set of 20 images. 

![fig7](https://user-images.githubusercontent.com/19624843/63905928-d6cc8e80-c9e3-11e9-8a1a-62555092283f.jpg)

![fig8](https://user-images.githubusercontent.com/19624843/63905936-de8c3300-c9e3-11e9-8d53-30bd80f04132.jpg)

## 5 Image Classification
After successfully detecting vehicles in images, the next step would be to select feature vectors, from which covariance matrices would be calculated for each pixel in a region. 

### 5.1 Feature Vectors 
We use similar feature vectors as used in [3] but do not consider the color components, as a vehicle color does not tell us much about it’s size. The feature vector which we decided to use is given by equation 6. The first order derivatives in the feature vector in the x and y directions is approximated by convolution with a 3x3 Sobel operator given by equation 7. The second order derivatives is approximated by convolution with a 3x3 Laplacian matrix, given by equation 8. 

### 5.2 Covariance Matrix 
The Covariance matrix Ck for a given region Rk is calculated by creating a feature vector Fi for each pixel in Rk. This is given in equation 9. These Covariance Matrices for the different regions is compared with target images’ region Covariance matrices using a distance metric, given by Forstner et al. [5]. This distance metric is given in equation 10. Here, µ(u) represents the average value of the feature in the feature vector for all pixels in the region Rk. λi(C1,C2) represents the generalized eigenvalues between C1 and C2.

![eqn4](https://user-images.githubusercontent.com/19624843/63905959-ee0b7c00-c9e3-11e9-9fe0-20046637e5f7.JPG)

![eqn5](https://user-images.githubusercontent.com/19624843/63906305-763e5100-c9e5-11e9-911e-5c394c24daa5.JPG)

### 5.3 Class Creation 
Another image set is made, containing a large amount of diverse vehicles and overlaps to develop a library of covariance matrices divided into 2 categories – {Car, Truck}. Each class comprises of covariance matrices of 50 vehicles, which are labelled manually. We then determine what class of object a given region Ri contains, by calculating the distance between Ci and every matrix in the library. The minimum distance is then taken and the region is identified as the same class as the object it was closest too, similar to k-means clustering, with k equal to 2 in this case. Figure 9, 10, and 11 show truck classification of a moderate size truck, an 18 wheeler, and multiple car classification respectively. 

![fig9](https://user-images.githubusercontent.com/19624843/63905940-e0ee8d00-c9e3-11e9-9cf7-c887ab646a98.jpg)

![fig10](https://user-images.githubusercontent.com/19624843/63905981-fc599800-c9e3-11e9-9b2d-a0fe21b1f6b9.jpg)

![fig11](https://user-images.githubusercontent.com/19624843/63905983-febbf200-c9e3-11e9-83c6-1fab78fbba34.jpg)

## 6 Results
Some of the results produced by the algorithm are listed in Table 1. The sensitivity metric is defined as follows:

![eqn6](https://user-images.githubusercontent.com/19624843/63906110-8a358300-c9e4-11e9-9a04-19d0d42939ce.JPG)



