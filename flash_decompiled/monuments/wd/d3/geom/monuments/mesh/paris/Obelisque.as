﻿package wd.d3.geom.monuments.mesh.paris {
    import fr.seraf.stage3D.*;
    import __AS3__.vec.*;

    public class Obelisque extends Stage3DData {

        public function Obelisque(){
            vertices = new <Number>[-7.87402, 3.05176E-5, 7.87401, 7.87402, 3.05176E-5, -7.87402, -7.87402, 3.05176E-5, -7.87402, 7.87402, 3.05176E-5, 7.87401, -7.87402, 3.93703, -7.87402, -7.10341, 3.93703, -7.10341, -7.87402, 3.93703, 7.87401, 7.87402, 3.93703, -7.87402, 7.10341, 3.93703, -7.10341, 7.10341, 3.93703, 7.10341, -7.10341, 3.93703, 7.10341, 7.87402, 3.93703, 7.87401, 7.10341, 7.87405, 7.10341, -6.96849, 30.7914, 6.96849, -6.96849, 30.7914, -6.96849, 6.96849, 30.7914, 6.96849, 6.3304, 30.7914, 6.3304, 6.96849, 30.7914, -6.96849, -6.96849, 31.6024, 6.96849, -6.96849, 31.6024, -6.96849, 6.96849, 31.6024, -6.96849, 6.96849, 31.6024, 6.96849, -7.49496, 31.6024, 7.49496, -7.49496, 31.6024, -7.49496, 7.49496, 31.6024, 7.49496, 7.49496, 31.6024, -7.49496, -7.49496, 33.1575, -7.49496, -6.6501, 33.1575, -6.6501, -7.49496, 33.1575, 7.49496, 7.49496, 33.1575, -7.49496, 6.6501, 33.1575, -6.6501, 6.6501, 33.1575, 6.6501, -6.6501, 33.1575, 6.6501, 7.49496, 33.1575, 7.49496, -6.6501, 34.9567, -6.6501, -6.07683, 34.9567, -6.07683, -6.6501, 34.9567, 6.6501, 6.6501, 34.9567, -6.6501, 6.6501, 34.9567, 6.6501, -6.48938, 9.84254, -6.48938, 6.3304, 30.7914, -6.3304, 0.169673, 161.572, -0.0523381, 0.0253662, 161.572, -0.0523381, -4.00719, 147.366, -3.99855, -3.91466, 147.366, -3.90393, -4.00719, 147.366, 3.97546, 3.7906, 147.366, -3.99855, 3.69807, 147.366, -3.90393, -3.91466, 147.366, 3.88084, 3.7906, 147.366, 3.97546, -6.48938, 10.63, -6.48938, -6.3304, 10.63, -6.3304, -6.48938, 10.63, 6.48938, 6.48938, 10.63, -6.48938, 6.3304, 10.63, -6.3304, -6.3304, 10.63, 6.3304, 6.48938, 10.63, 6.48938, -6.3304, 30.7914, 6.3304, -6.3304, 30.7914, -6.3304, 6.3304, 10.63, 6.3304, -6.07683, 34.9567, 6.07683, 6.07683, 34.9567, -6.07683, 6.07683, 34.9567, 6.07683, 0.0253662, 161.572, 0.169674, 3.69807, 147.366, 3.88084, 0.169673, 161.572, 0.169674, -7.10341, 7.87405, 7.10341, 6.48938, 9.84254, 6.48938, 7.10341, 7.87405, -7.10341, -6.48938, 9.84254, 6.48938, 6.48938, 9.84254, -6.48938, -7.10341, 7.87405, -7.10341, -7.10341, 7.87405, 6.48938];
            uvs = new <Number>[0.000499725, 0.000499487, 0.9995, 0.999501, 0.000499487, 0.9995, 0.999501, 0.000499725, 0.000499487, 0.9995, 0.0493839, 0.950616, 0.000499725, 0.000499487, 0.9995, 0.999501, 0.950616, 0.950616, 0.950616, 0.0493839, 0.0493842, 0.0493836, 0.999501, 0.000499725, 0.950616, 0.0493839, 0.0579429, 0.0579427, 0.0579427, 0.942057, 0.942057, 0.057943, 0.901579, 0.0984213, 0.942057, 0.942057, 0.0579429, 0.0579427, 0.0579427, 0.942057, 0.942057, 0.942057, 0.942057, 0.057943, 0.0245457, 0.0245453, 0.0245455, 0.975454, 0.975455, 0.0245456, 0.975454, 0.975454, 0.0245455, 0.975454, 0.0781404, 0.921859, 0.0245457, 0.0245453, 0.975454, 0.975454, 0.921859, 0.92186, 0.92186, 0.0781406, 0.0781406, 0.0781404, 0.975455, 0.0245456, 0.0781404, 0.921859, 0.114507, 0.885493, 0.0781406, 0.0781404, 0.921859, 0.92186, 0.92186, 0.0781406, 0.0883361, 0.911664, 0.901579, 0.901579, 0.510763, 0.50332, 0.501609, 0.50332, 0.245797, 0.753654, 0.251667, 0.747652, 0.245798, 0.24781, 0.740463, 0.753654, 0.734593, 0.747652, 0.251667, 0.253813, 0.740463, 0.24781, 0.0883361, 0.911664, 0.0984212, 0.901579, 0.0883362, 0.0883361, 0.911664, 0.911664, 0.901579, 0.901579, 0.0984214, 0.0984212, 0.911664, 0.0883363, 0.0984214, 0.0984212, 0.0984212, 0.901579, 0.901579, 0.0984213, 0.114507, 0.114507, 0.885493, 0.885493, 0.885493, 0.114507, 0.501609, 0.489236, 0.734593, 0.253813, 0.510763, 0.489236, 0.0493842, 0.0493836, 0.911664, 0.0883363, 0.950616, 0.950616, 0.0883362, 0.0883361, 0.911664, 0.911664, 0.0493839, 0.950616, 0.0493841, 0.0883361];
            indices = new <uint>[1, 0, 2, 0, 1, 3, 11, 9, 10, 2, 6, 4, 6, 2, 0, 3, 6, 0, 6, 3, 11, 7, 3, 1, 3, 7, 11, 2, 7, 1, 7, 2, 4, 72, 10, 66, 72, 5, 10, 72, 71, 5, 5, 68, 8, 68, 5, 71, 9, 68, 12, 68, 9, 8, 9, 66, 10, 66, 9, 12, 69, 12, 67, 12, 69, 66, 67, 68, 70, 68, 67, 12, 14, 18, 19, 18, 14, 13, 14, 20, 17, 20, 14, 19, 20, 15, 17, 15, 20, 21, 15, 18, 13, 18, 15, 21, 19, 23, 25, 33, 32, 28, 32, 33, 31, 24, 28, 22, 28, 24, 33, 23, 28, 26, 28, 23, 22, 23, 29, 25, 29, 23, 26, 29, 24, 25, 24, 29, 33, 38, 60, 36, 60, 38, 62, 27, 36, 34, 36, 27, 32, 27, 37, 30, 37, 27, 34, 37, 31, 30, 31, 37, 38, 31, 36, 32, 36, 31, 38, 39, 68, 71, 68, 39, 70, 69, 72, 66, 72, 39, 71, 69, 39, 72, 63, 41, 42, 41, 63, 65, 49, 48, 45, 48, 49, 64, 56, 59, 55, 53, 67, 70, 67, 53, 56, 67, 52, 69, 52, 67, 56, 39, 52, 50, 52, 39, 69, 39, 53, 70, 53, 39, 50, 51, 57, 58, 57, 51, 55, 51, 40, 54, 40, 51, 58, 40, 59, 54, 59, 40, 16, 59, 57, 55, 57, 59, 16, 60, 43, 35, 43, 60, 45, 35, 46, 61, 46, 35, 43, 62, 45, 60, 45, 62, 49, 46, 62, 61, 62, 46, 49, 48, 42, 44, 42, 48, 63, 44, 41, 47, 41, 44, 42, 64, 63, 48, 63, 64, 65, 41, 64, 47, 64, 41, 65, 44, 45, 48, 45, 44, 43, 44, 46, 43, 46, 44, 47, 46, 64, 49, 64, 46, 47, 35, 36, 60, 36, 35, 34, 27, 28, 32, 28, 27, 26, 37, 35, 61, 35, 37, 34, 29, 27, 30, 27, 29, 26, 37, 62, 38, 62, 37, 61, 29, 31, 33, 31, 29, 30, 25, 20, 19, 18, 24, 22, 24, 18, 21, 18, 23, 19, 23, 18, 22, 15, 40, 17, 40, 15, 16, 17, 58, 14, 58, 17, 40, 14, 57, 13, 57, 14, 58, 13, 16, 15, 16, 13, 57, 25, 21, 20, 21, 25, 24, 5, 6, 10, 6, 5, 4, 7, 5, 8, 5, 7, 4, 7, 9, 11, 9, 7, 8, 10, 6, 11, 51, 53, 50, 53, 51, 54, 53, 59, 56, 59, 53, 54, 55, 52, 56, 51, 52, 55, 52, 51, 50];
        }
    }
}//package wd.d3.geom.monuments.mesh.paris 
