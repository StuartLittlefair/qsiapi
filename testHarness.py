import time
import qsiapi
import sys
import numpy

def display():
    import numdisplay
    import scipy.stats as stats    
    minVal = stats.scoreatpercentile(image,5)
    maxVal = stats.scoreatpercentile(image,95)    
    numdisplay.display(image,z1=minVal,z2=maxVal)

def updateFitsHeader(hdr):
    
    #gather information and append to header, or update if already there
    status, dateObs = cam.get_LastExposureStartTime()
    hdr.update(key="DATE-OBS", value=dateObs, comment="YYYY-MM-DDThh:mm:ss observation start, UT")

    status, exposure = cam.get_LastExposureDuration()
    hdr.update(key="EXPOSURE", value=exposure, comment="Exposure time in seconds")
    hdr.update(key="EXPTIME", value=exposure, comment="Exposure time in seconds")

    status, ccdSetTemp = cam.get_SetCCDTemperature()
    hdr.update(key="SET-TEMP", value=ccdSetTemp, comment="CCD temperature setpoint in C")
    status, ccdActualTemp = cam.get_CCDTemperature()
    hdr.update(key="CCD-TEMP", value=ccdActualTemp, comment="CCD temperature in C")

    status, xbin = cam.get_BinX()
    hdr.update(key="XBINNING", value=xbin, comment="Binning factor in width")    
    status, ybin = cam.get_BinY()
    hdr.update(key="YBINNING", value=ybin, comment="Binning factor in height")    

    status, xPixSz = cam.get_PixelSizeX()
    xPixSz = xPixSz * xbin
    status, yPixSz = cam.get_PixelSizeY()
    yPixSz = yPixSz * ybin
    hdr.update(key="XPIXSZ", value=xPixSz, comment="Pixel Width in microns (after binning)")    
    hdr.update(key="YPIXSZ", value=yPixSz, comment="Pixel Height in microns (after binning)")    

    status, startX = cam.get_StartX()
    status, startY = cam.get_StartY()
    xOrgSubF = startX/xbin
    yOrgSubF = startY/ybin
    hdr.update(key="XORGSUBF", value=xOrgSubF, comment="Subframe X position in binned pixels")    
    hdr.update(key="YORGSUBF", value=yOrgSubF, comment="Subframe Y position in binned pixels")    

    status, egain = cam.get_ElectronsPerADU()
    hdr.update(key="EGAIN", value=egain, comment="Electronic gain in e-/ADU")    

    status, instrume = cam.get_ModelNumber()
    instrume = instrume.replace('\x00','')
    if (instrume == '532ws-M2'):
        instrume = 'QSI 532'
    hdr.update(key="INSTRUME", value=instrume, comment="instrument or camera used")    

    
    filters = cam.get_Names()
    status, position = cam.get_Position()
    thisFilter = filters[position]
    hdr.update(key="FILTER", value=thisFilter, comment="Filter used when taking image")    
    

def writeFits(filename):
    import pyfits
    hdu = pyfits.PrimaryHDU(image)
    updateFitsHeader(hdu.header)
    hdulist = pyfits.HDUList([hdu])
    hdulist.writeto(filename,clobber=True)
    print "written fits file to ", filename


cam = qsiapi.QSICamera()
status,info = cam.get_DriverInfo()
print "qsiapi version", info

serials,descs,numcams=cam.get_AvailableCameras()
if (numcams <1):
    sys.exit('No Cameras Found')

cam.put_SelectCamera(serials[0])
cam.put_IsMainCamera(True)
cam.put_Connected(True)
status, modelNumber = cam.get_ModelNumber()
modelNumber = modelNumber.replace('\x00','')
status, desc = cam.get_Description()
print "Connected to ", modelNumber, ": ", desc

filters = ('U','B','V','R','I')
cam.put_Names(filters)
newFilters = cam.get_Names()
cam.put_Position(2)
status, filterPos = cam.get_Position()
print 'Selected filter ', newFilters[filterPos]

cam.put_FocusOffset([0,0,0,0,0])
offsets =  cam.get_FocusOffset()

binFac = int(raw_input('> Enter binning factor for image: '))
status = cam.put_BinX(binFac)
status = cam.put_BinY(binFac)
status, xsize = cam.get_CameraXSize()
status, ysize = cam.get_CameraYSize()
status = cam.put_StartX(0)
status = cam.put_StartY(0)
status = cam.put_NumX(int(xsize/binFac))
status = cam.put_NumY(int(ysize/binFac))

# take 3s exposure, no shutter open
print "Starting 3s exposure"
cam.StartExposure(3.00, False)
status, done = cam.get_ImageReady()
while(not done):
    time.sleep(0.5)
    status, done = cam.get_ImageReady()

print "Image Taken"
status, xs,ys,els = cam.get_ImageArraySize()
print "Image Dimensions: %d, %d, %d"  % (xs,ys,els)
status, image = cam.get_ImageArray(xs*ys)
image = numpy.reshape(image,(ys,xs),order='C')
    
writeFits('test.fits')
print "Written frame to 'test.fits'"

cam.put_Connected(False)
print "disconnected"
