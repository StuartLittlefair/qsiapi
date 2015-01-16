from libcpp cimport bool
from libcpp.string cimport string
from libcpp.vector cimport vector

cdef extern from "qsiapi.h":
    cdef cppclass cQSICamera "QSICamera":
        cQSICamera() except+
        int MAXCAMERAS
        
        # Camera
        int get_BinX(short* pVal) except+
        int put_BinX(short newVal) except+
        int get_BinY(short* pVal) except+
        int put_BinY(short newVal) except+
        int get_CameraState(CameraState* pVal) except+
        int get_CameraXSize(long* pVal) except+
        int get_CameraYSize(long* pVal) except+
        int get_CanAbortExposure(bool* pVal)
        int get_CanAsymmetricBin(bool* pVal)
        int get_CanGetCoolerPower(bool* pVal)
        int get_CanPulseGuide(bool* pVal)
        int get_CanSetCCDTemperature(bool* pVal)
        int get_CanStopExposure(bool* pVal)
        int get_CCDTemperature(double* pVal) except+
        int get_Connected(bool* pVal) except+
        int put_Connected(bool newVal) except+
        int get_CoolerOn(bool* pVal) except+
        int put_CoolerOn(bool newVal) except+
        int get_CoolerPower(double* pVal) except+
        int get_Description(string& pVal) except+
        int get_DriverInfo(string& pVal) except+
        int get_ElectronsPerADU(double* pVal) except+
        int get_FullWellCapacity(double* pVal) except+
        int get_HasFilterWheel(bool* pVal) except+
        int get_HasShutter(bool* pVal) except+
        int get_HeatSinkTemperature(double* pVal) except+
        int get_ImageArraySize(int& xSize, int& ySize, int& elementSize) except+
        int get_ImageArray(unsigned short* pVal) except+
        int get_ImageArray(double * pVal) except+
        int get_ImageReady(bool* pVal) except+
        int get_IsMainCamera(bool* pVal) except+
        int put_IsMainCamera(bool newVal) except+
        int get_IsPulseGuiding(bool* pVal) except+
        int get_LastError(string& pVal) except+
        int get_LastExposureDuration(double* pVal) except+
        int get_LastExposureStartTime(string& pVal) except+
        int get_MaxADU(long* pVal) except+
        int get_MaxBinX(short* pVal) except+
        int get_MaxBinY(short* pVal) except+
        int get_ModelNumber(string& pVal) except+
        int get_Name(string& pVal) except+
        int get_NumX(long* pVal) except+
        int put_NumX(long newVal) except+
        int get_NumY(long* pVal) except+
        int put_NumY(long newVal) except+
        int get_PixelSizeX(double* pVal) except+
        int get_PixelSizeY(double* pVal) except+
        int get_PowerOfTwoBinning(bool* pVal)
        int get_SerialNumber(string& pVal) except+
        int get_SetCCDTemperature(double* pVal) except+
        int put_SetCCDTemperature(double newVal) except+
        int get_StartX(long* pVal) except+ 
        int put_StartX(long newVal) except+
        int get_StartY(long* pVal) except+
        int put_StartY(long newVal) except+
        int AbortExposure() except+
        int PulseGuide(int Direction, long Duration) except+
        int StartExposure(double Duration, bool Light) except+
        int StopExposure() except+

        int put_SelectCamera(string serialNum) except+
        int get_SelectCamera(string& serialNum) except+
        int get_AvailableCameras(string *cameraSerial, string *cameraDesc, int& numFound) except+

        int put_UseStructuredExceptions(bool newVal)

        #Advanced settings
        int get_SoundEnabled(bool& pVal) except+
        int put_SoundEnabled(bool newVal) except+
        int get_LEDEnabled(bool& pVal) except+
        int put_LEDEnabled(bool newVal) except+
        int get_FanMode(int& pVal) except+
        int put_FanMode(int newVal) except+
        int get_FlushCycles(int& pVal) except+
        int put_FlushCycles(int newVal) except+
        int get_ShutterMode(int& pVal) except+
        int put_ShutterMode(int newVal) except+
        int get_ReadoutSpeed(int& pVal) except+
        int put_ReadoutSpeed(int newVal) except+
    
        # FilterWheel Methods
        int get_FilterCount(int& count) except+
        int get_Names( string* names) except+
        int put_Names( string* names) except+
        int get_Position( short* pVal ) except+
        int put_Position( short newVal ) except+
        int get_FocusOffset( long pVal[] ) except+
        int put_FocusOffset( long newVal[] ) except+
        int get_FilterWheelConnected(bool * pVal) except+
        int put_FilterWheelConnected(bool newVal) except+

        # Custom Controls
        int put_EnableShutterStatusOutput(bool newVal) except+
        int get_EnableShutterStatusOutput(bool* pVal) except+	
        int get_ManualShutterMode(bool * pVal) except+
        int put_ManualShutterMode(bool newVal) except+
        int put_ManualShutterOpen(bool newVal) except+

        # 520 extensions
        int get_CameraGain(int * pVal) except+
        int put_CameraGain(int newVal) except+
        int get_AntiBlooming(int * pVal) except+
        int put_AntiBlooming(int newVal) except+
        int get_ShutterPriority(int * pVal) except+
        int put_ShutterPriority(int newVal) except+
        int get_PreExposureFlush(int * pVal) except+
        int put_PreExposureFlush(int newVal) except+
        int put_HostTimedExposure(bool newVal) except+
        #
        # Diagnostics
        #
        int get_LastOverscanMean( unsigned short * pVal ) except+
        #
        # QSI Extensions
        #
        int get_MinExposureTime( double * pVal ) except+
        int get_MaxExposureTime( double * pVal ) except+
        int get_QSIDeviceCount(short * pVal) except+
        int get_QSISelectedDevice(string& pVal) except+
        int put_QSISelectedDevice(string newVal) except+
        int get_QSISerialNumbers(string *pVal, int * iNumFound) except+
        int QSIRead( unsigned char * Buffer, int BytesToRead, int * BytesReturned) except+
        int QSIWrite( unsigned char * Buffer, int BytesToWrite, int * BytesWritten) except+
        int get_QSIReadDataAvailable(int * pVal ) except+
        int get_QSIWriteDataPending( int * pVal ) except+
        int put_QSIReadTimeout( int newVal ) except+
        int put_QSIWriteTimeout( int newVal ) except+
        int put_QSIOpen( bool newVal ) except+
        int get_CanSetGain(bool* pVal) except+
        int put_MaskPixels(bool newVal) except+
        int get_MaskPixels(bool* pVal) except+
        int put_PixelMask(vector[cPixel] pixels) except+
        int get_PixelMask(vector[cPixel] *pixels) except+
        int get_FilterPositionTrim( vector[short] * pVal) except+
        int put_FilterPositionTrim( vector[short]) except+
        int get_HasFilterWheelTrim(bool* pVal) except+
        int get_FilterWheelNames( vector[string] * pVal) except+
        int get_SelectedFilterWheel(string * pVal) except+
        int put_SelectedFilterWheel(string newVal) except+
        int NewFilterWheel(string Name) except+
        int DeleteFilterWheel(string Name) except+
        int get_PCBTemperature(double* pVal) except+
        int HSRImage(double Duration, unsigned short * Image) except+
        int put_HSRMode(bool newVal) except+
        int Flush() except+
        int EnableTriggerMode(int newVal1, int newVal2) except+
        int TerminatePendingTrigger() except+
        int CancelTriggerMode() except+
        int get_ShutterState( int * pVal) except+

cdef extern from "qsiapi.h" namespace "QSICamera":
    enum CameraState:
        CameraIdle      = 0
        CameraWaiting   = 1
        CameraExposing  = 2
        CameraReading   = 3
        CameraDownload  = 4
        CameraError     = 5
		        
cdef extern from "qsiapi.h":
    cdef cppclass cPixel "Pixel":
        cPixel(int, int)
        int x
        int y
        
