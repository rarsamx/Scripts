import re

def simpleGrep(fileName, patternStr) :
  result = ""
  pattern = re.compile(patternStr)
  file = open (fileName, "r")
  for line in file :
    matchObject = pattern.match(line)
    if matchObject != None :
      result = result + matchObject.group(1) + "\n" 
  return result
  

MNTDEVS = simpleGrep("/proc/mounts","/\w+/(hd\w*|sd\w*|scd\w*|sr\w*|mmc\w*)").replace("\n"," ")

print (MNTDEVS)

