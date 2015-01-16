# distutils: language = c++
import numpy as np
cimport numpy as np
from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.list cimport list as cpplist
from cython.operator cimport dereference as deref

cdef class Pixel:
    cdef cPixel *thisptr
    def __cinit__(self,int x, int y):
        self.thisptr = new cPixel(x,y)
    def __dealloc__(self):
        del self.thisptr
    property x:
        def __get__(self):
            return self.thisptr.x
        def __set__(self, int val):
            self.thisptr.x =  val
    property y:
        def __get__(self):
            return self.thisptr.x
        def __set__(self, int val):
            self.thisptr.x =  val
     
cdef class QSICamera:

    cdef cQSICamera *thisptr

    def __cinit__(self):
        self.thisptr = new cQSICamera()

    def __dealloc__(self):
        del self.thisptr

    def get_DriverInfo(self):
        cdef string s
        cdef int retVal
        retVal = self.thisptr.get_DriverInfo(s)
        return retVal, s

    def get_AvailableCameras(self):
        # create vectors of strings. Elements in a vector are guaranteed to be contiguous, like an array
        # this means that &vect[0] is like an array of strings (which I can't create any other way!)
        cdef vector[string] cameraSerial = ["" for i in xrange(self.thisptr.MAXCAMERAS)]
        cdef vector[string] cameraDesc = ["" for i in xrange(self.thisptr.MAXCAMERAS)]
        cdef int numFound = 0    
        
        retVal = self.thisptr.get_AvailableCameras(&cameraSerial[0],&cameraDesc[0],numFound)
        return cameraSerial[0:numFound], cameraDesc[0:numFound], numFound

    def get_FilterCount(self):
        cdef int retVal, nfilt
        retVal = self.thisptr.get_FilterCount(nfilt)
        return nfilt
        
    def get_Names(self):
        # see available cameras for string array fudge
        nfilt = self.get_FilterCount()
        cdef vector[string] names = ["" for i in xrange(nfilt)] # five positions hard coded
        cdef int retVal
        retVal = self.thisptr.get_Names(&names[0])
        return names
        
    def put_Names(self,names):
        # see available cameras for string array fudge
        nfilt = self.get_FilterCount()
        assert len(names) == nfilt, "Need %d filter names" % nfilt
        cdef vector[string] cnames = [names[i] for i in xrange(nfilt)]
        cdef retVal
        retVal = self.thisptr.put_Names(&cnames[0])
        return retVal
        
    def AbortExposure(self):
        cdef int retVal
        retVal = self.thisptr.AbortExposure()
        return retVal

    def StartExposure(self,double expT, bool shutterOpen):
        return self.thisptr.StartExposure(expT,shutterOpen)
        
    def get_BinX(self):
        cdef int retVal
        cdef short binX
        retVal = self.thisptr.get_BinX(&binX)
        return retVal, binX
        
    def put_BinX(self,short val):
        cdef int retVal
        retVal = self.thisptr.put_BinX(val)
        return retVal

    def get_BinY(self):
        cdef int retVal
        cdef short binY
        retVal = self.thisptr.get_BinY(&binY)
        return retVal, binY
        
    def put_BinY(self,short val):
        cdef int retVal
        retVal = self.thisptr.put_BinY(val)
        return retVal

    def get_StartX(self):
        cdef int retVal
        cdef long StartX
        retVal = self.thisptr.get_StartX(&StartX)
        return retVal, StartX
        
    def put_StartX(self,long val):
        cdef int retVal
        retVal = self.thisptr.put_StartX(val)
        return retVal

    def get_StartY(self):
        cdef int retVal
        cdef long StartY
        retVal = self.thisptr.get_StartY(&StartY)
        return retVal, StartY
        
    def put_StartY(self,long val):
        cdef int retVal
        retVal = self.thisptr.put_StartY(val)
        return retVal

    def get_NumX(self):
        cdef int retVal
        cdef long NumX
        retVal = self.thisptr.get_NumX(&NumX)
        return retVal, NumX
        
    def put_NumX(self,long val):
        cdef int retVal
        retVal = self.thisptr.put_NumX(val)
        return retVal

    def get_NumY(self):
        cdef int retVal
        cdef long NumY
        retVal = self.thisptr.get_NumY(&NumY)
        return retVal, NumY
        
    def put_NumY(self,long val):
        cdef int retVal
        retVal = self.thisptr.put_NumY(val)
        return retVal
       
    def get_Connected(self):
        cdef int retVal
        cdef bool conn
        retVal = self.thisptr.get_Connected(&conn)
        return retVal, conn
        
    def put_Connected(self,bool conn):
        cdef int retVal
        retVal = self.thisptr.put_Connected(conn)
        return retVal      
        
    def get_CCDTemperature(self):
        cdef int retVal
        cdef double temp
        retVal = self.thisptr.get_CCDTemperature(&temp)
        return retVal, temp
 
    def get_CameraState(self):
        cdef int retVal
        cdef CameraState state
        retVal = self.thisptr.get_CameraState(&state)
        return state       

    def get_CameraXSize(self):
        cdef int retVal
        cdef long val
        retVal = self.thisptr.get_CameraXSize(&val)
        return retVal, val 

    def get_CameraYSize(self):
        cdef int retVal
        cdef long val
        retVal = self.thisptr.get_CameraYSize(&val)
        return retVal, val 
        
    def get_Description(self):
        cdef string val
        cdef int retVal
        retVal = self.thisptr.get_Description(val)
        return retVal, val
        
    def get_ElectronsPerADU(self):
        cdef int retVal
        cdef double val
        retVal = self.thisptr.get_ElectronsPerADU(&val)
        return retVal, val 
        
    def get_FocusOffset(self):
        nfilt = self.get_FilterCount()
        cdef np.ndarray[long, ndim=1] offsets = np.zeros(nfilt, dtype=np.int)
        cdef int retVal
        retVal = self.thisptr.get_FocusOffset(<long*> offsets.data)
        return retVal, offsets
        
    def put_FocusOffset(self,offsets):
        cdef int retVal
        nfilt = self.get_FilterCount()
        assert len(offsets) == nfilt, "Need %d filter position offsets" % nfilt
        cdef np.ndarray[long, ndim=1] coff = np.array(offsets).astype(np.int)
        retVal = self.thisptr.put_FocusOffset(<long*> coff.data)
        return retVal
        
    def get_ImageArray(self,size):
        cdef np.ndarray[unsigned short, ndim=1] im = np.zeros(size, dtype=np.uint16)
        cdef int retVal
        retVal = self.thisptr.get_ImageArray(<unsigned short*> im.data)
        return retVal, im
    
    def get_ImageArraySize(self):
        cdef int xs, ys, es, retVal
        retVal = self.thisptr.get_ImageArraySize(xs,ys,es)
        return retVal, xs, ys, es
        
    def get_ImageReady(self):
        cdef bool ready
        cdef int retVal
        retVal = self.thisptr.get_ImageReady(&ready)
        return retVal, ready
        
    def get_LastExposureDuration(self):
        cdef int retVal
        cdef double val
        retVal = self.thisptr.get_LastExposureDuration(&val)
        return retVal, val 
   
    def get_LastExposureStartTime(self):
        cdef int retVal
        cdef string val
        retVal = self.thisptr.get_LastExposureStartTime(val)
        return retVal, val
        
    def get_ModelNumber(self):
        cdef int retVal
        cdef string val
        retVal = self.thisptr.get_ModelNumber(val)
        return retVal, val
        
    def get_PixelSizeX(self):
        cdef int retVal
        cdef double val
        retVal = self.thisptr.get_PixelSizeX(&val)
        return retVal, val
        
    def get_PixelSizeY(self):
        cdef int retVal
        cdef double val
        retVal = self.thisptr.get_PixelSizeY(&val)
        return retVal, val  

    def get_Position(self):
        cdef int retVal
        cdef short val
        retVal = self.thisptr.get_Position(&val)
        return retVal, val
        
    def put_Position(self, short pos):
        cdef int retVal
        retVal = self.thisptr.put_Position(pos)
        return retVal
        
    def get_SetCCDTemperature(self):
        cdef int retVal
        cdef double val
        retVal = self.thisptr.get_SetCCDTemperature(&val)
        return retVal, val 
    
    def put_SetCCDTemperature(self,double val):
        cdef int retVal
        retVal = self.thisptr.put_SetCCDTemperature(val)
        return retVal

    def put_CoolerOn(self,bool cool):
        cdef int retVal
        retVal = self.thisptr.put_CoolerOn(cool)
        return retVal      

    def put_IsMainCamera(self,bool main):
        cdef int retVal
        retVal = self.thisptr.put_IsMainCamera(main)
        return retVal      
    
    def put_SelectCamera(self,string serial):
        cdef int retVal
        retVal = self.thisptr.put_SelectCamera(serial)
        return retVal
