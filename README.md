# DeepSim

MATLAB code of DeepSim, a full-reference image quality assessment (FR-IQA) method based on deep learning. 

## Paper

**Fei Gao**, Yi Wang, Panpeng Li, Min Tan, Jun Yu, Yani Zhu, "DeepSim: Deep similarity for image quality assessment," Neurocomputing, vol. 157, pp. 104-114, 2017. [PDF](https://www.sciencedirect.com/science/article/pii/S0925231217301480?via%3Dihub)

**bib:**

> @article{GAO2017DeepSim,
> title = "DeepSim: Deep similarity for image quality assessment",
> journal = "Neurocomputing",
> volume = "257",
> pages = "104 - 114",
> year = "2017",
> issn = "0925-2312",
> doi = "https://doi.org/10.1016/j.neucom.2017.01.054",
> author = "Fei Gao and Yi Wang and Panpeng Li and Min Tan and Jun Yu and Yani Zhu",
> }

## Usage

1. This work is based on ``MATLAB``;
2. Before use this code, please download the VGG16 network pretrained on ImageNet, ``imagenet-vgg-verydeep-16.mat``, and put it under a subfolder ``/data``
3. ``FR_DeepSim.m`` is the main function;
4. ``FR_DeepSim_demo.m`` is an example, ``imageDis.bmp`` is a distorted image,  ``imageRef.bmp`` is the corresponding refernce/undistorted image.
5. ``pooling.m`` includes different pooling methods;
6. ``CNN paractical.pdf`` introduce the ``matconvnet`` toolbox: http://www.vlfeat.org/matconvnet/;
7. ``vlfeat`` : http://www.vlfeat.org/

