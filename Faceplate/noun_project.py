import os
import urllib
import zipfile
import StringIO

N = 547
template = "http://www.thenounproject.com/site_media/zipped/svg_%d.zip"

for i in range(1, N + 1):
    out = 'Images/NounProject/noun_project_%d.svg' % i
    if not os.path.exists(out):
        try:
            u = urllib.urlopen(template % i)
            s = StringIO.StringIO()
            s.write(u.read())
            s.seek(0)
            z = zipfile.ZipFile(s)
            z.extractall(path='Images/NounProject/')
        except zipfile.BadZipfile:
            print 'Bad file: %s' % (template % i)
            s.seek(0)
            f = open('Images/NounProject/noun_project_%d.zip' % i, 'wb')
            f.write(s.read())


