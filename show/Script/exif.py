# -*- coding: utf-8 -*-
import os
import json
from PIL.ExifTags import TAGS, GPSTAGS
from PIL import Image, ImageFile

__all__ = ['fix_orientation']

# PIL's Error "Suspension not allowed here" work around:
# s. http://mail.python.org/pipermail/image-sig/1999-August/000816.html
ImageFile.MAXBLOCK = 1024*1024

# The EXIF tag that holds orientation data.
EXIF_ORIENTATION_TAG = 274

# Obviously the only ones to process are 3, 6 and 8.
# All are documented here for thoroughness.
ORIENTATIONS = {
    1: ("Normal", 0),
    2: ("Mirrored left-to-right", 0),
    3: ("Rotated 180 degrees", 180),
    4: ("Mirrored top-to-bottom", 0),
    5: ("Mirrored along top-left diagonal", 0),
    6: ("Rotated 90 degrees", -90),
    7: ("Mirrored along top-right diagonal", 0),
    8: ("Rotated 270 degrees", -270)
}

def fix_orientation(img, save_over=False):
    """
    `img` can be an Image instance or a path to an image file.
    `save_over` indicates if the original image file should be replaced by the new image.
    * Note: `save_over` is only valid if `img` is a file path.
    """
    path = None
    if not isinstance(img, Image.Image):
        path = img
        img = Image.open(path)
    elif save_over:
        raise ValueError("You can't use `save_over` when passing an Image instance.  Use a file path instead.")
    try:
    	exif  = img._getexif()
    	if (exif is not None and EXIF_ORIENTATION_TAG in exif):
        	orientation = exif[EXIF_ORIENTATION_TAG]
        else:
        	orientation = "Normal"
    except (TypeError, AttributeError, KeyError):
        raise ValueError("Image file has no EXIF data.")
    if orientation in [3,6,8]:
        degrees = ORIENTATIONS[orientation][1]
        img = img.rotate(degrees)
        if save_over and path is not None:
            try:
                img.save(path, quality=95, optimize=1)
            except IOError:
                # Try again, without optimization (PIL can't optimize an image
                # larger than ImageFile.MAXBLOCK, which is 64k by default).
                # Setting ImageFile.MAXBLOCK should fix this....but who knows.
                img.save(path, quality=95)
        return (img, degrees)
    else:
        return (img, 0)

def get_exif_data(image):
	"""Returns a dictionary from the exif data of an PIL Image item. Also converts the GPS Tags"""
	exif_data = {}
	info = image._getexif()
	if info:
		for tag, value in info.items():
			decoded = TAGS.get(tag, tag)
			if decoded == "GPSInfo":
				gps_data = {}
				for t in value:
					sub_decoded = GPSTAGS.get(t, t)
					gps_data[sub_decoded] = value[t]
 
				exif_data[decoded] = gps_data
			else:
				exif_data[decoded] = value
 
	return exif_data
 
def _get_if_exist(data, key):
	if key in data:
		return data[key]
		
	return None
	
def _convert_to_degress(value):
	"""Helper function to convert the GPS coordinates stored in the EXIF to degress in float format"""
	d0 = value[0][0]
	d1 = value[0][1]
	d = float(d0) / float(d1)
 
	m0 = value[1][0]
	m1 = value[1][1]
	m = float(m0) / float(m1)
 
	s0 = value[2][0]
	s1 = value[2][1]
	s = float(s0) / float(s1)
 
	return d + (m / 60.0) + (s / 3600.0)
 
def get_lat_lon(exif_data):
	"""Returns the latitude and longitude, if available, from the provided exif_data (obtained through get_exif_data above)"""
	lat = None
	lon = None
 
	if "GPSInfo" in exif_data:		
		gps_info = exif_data["GPSInfo"]
 
		gps_latitude = _get_if_exist(gps_info, "GPSLatitude")
		gps_latitude_ref = _get_if_exist(gps_info, 'GPSLatitudeRef')
		gps_longitude = _get_if_exist(gps_info, 'GPSLongitude')
		gps_longitude_ref = _get_if_exist(gps_info, 'GPSLongitudeRef')
 
		if gps_latitude and gps_latitude_ref and gps_longitude and gps_longitude_ref:
			lat = _convert_to_degress(gps_latitude)
			if gps_latitude_ref != "N":					 
				lat = 0 - lat
 
			lon = _convert_to_degress(gps_longitude)
			if gps_longitude_ref != "E":
				lon = 0 - lon
 
	return lat, lon
 
def get_json_file(inpath,outpath,filename="photos.json"):
	photoInfos={}
	id  = 0
	for root, dir, files in os.walk(inpath):
		for photo in files:
#			print root+'/'+photo
			image = Image.open(root+'/'+photo)
			exif_data = get_exif_data(image)
			latitude ,longitude = get_lat_lon(exif_data)
			photoInfos[id] = {"src":('Images/Photos/tumbnails/'+photo),'tumb':('Images/Photos/tumbnails/'+photo),'name':photo,'latitude':latitude,'longitude':longitude}
			id+=1
			fix_orientation(root+'/'+photo,True)
			# savetumbs
			if savetumbs:
				basewidth = 300
				wpercent = (basewidth / float(image.size[0]))
				hsize = int((float(image.size[1]) * float(wpercent)))
				img = image.resize((basewidth, hsize),Image.ANTIALIAS)
				img.save(root+'/tumbnails/'+photo) 

	os.chdir(outpath)
	with open(outpath+'/'+filename,'w') as f:
		json.dump(photoInfos,f)
	print photoInfos

################
# Example ######
################
if __name__ == "__main__":
	savetumbs = True
	inpath ="/var/www/html/Images/Photos"
	outpath  ="/var/www/html/Ajax"
	get_json_file(inpath,outpath)


