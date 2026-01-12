# Move oversize images to IMG-maxheight or IMG-maxwidth
for i in IMG*.jpg
  echo $i
  set w (identify $i | grep -Eo ' ([0-9]{2,})x([0-9]{2,}) '|awk '{$1=$1};1' | cut -d 'x' -f 1)
  set h (identify $i | grep -Eo ' ([0-9]{2,})x([0-9]{2,}) '|awk '{$1=$1};1' | cut -d 'x' -f 2)
  echo 'width' $w 'height' $h
  if test "$h" -gt "$w"
      echo 'taller'
      mv $i IMG-maxheight/
  else if test "$w" -ge "$h"
      echo 'wider or square'
      mv $i IMG-maxwidth/
  end
end
