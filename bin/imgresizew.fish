# Resize too wide images to 1000 px
# Do we need this? Probably just want max height because panoramas are nice
for i in *.jpg
    echo $i
    magick $i -resize '1000' ../$i
end
