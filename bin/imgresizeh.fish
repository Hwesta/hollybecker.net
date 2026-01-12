# Resize too tall images to 1000px
for i in *.jpg
    echo $i
    magick $i -resize 'x1000' ../$i
end
