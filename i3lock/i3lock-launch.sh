INSIDE_COLOR='#1C2023BF'
RING_COLOR='#15181BCF'
LINE_COLOR='#15181BC9'
INSIDE_VERIFY_COLOR='#15181BCF' 
RING_VERIFY_COLOR='#3EFFA8CF'
INSIDE_WRONG_COLOR='#FF5555BF'
RING_WRONG_COLOR='#FFA7A7CF'
KEYHL_COLOR='#3EFFA8CF'
BSHL_COLOR='#FF5555CF'
TEXT_COLOR='#C7CCD1'
TEXT_FONT=FiraCodeNerdFontPropo-Regular 

i3lock-color  --color FFFFFF --blur 15 \
              --inside-color=$INSIDE_COLOR \
              --ring-color=$RING_COLOR \
              --line-color=$LINE_COLOR \
              --insidever-color=$INSIDE_VERIFY_COLOR \
              --ringver-color=$RING_VERIFY_COLOR \
              --insidewrong-color=$INSIDE_WRONG_COLOR \
              --ringwrong-color="$RING_WRONG_COLOR" \
              --keyhl-color=$KEYHL_COLOR \
              --bshl-color=$BSHL_COLOR \
              --verif-text="Running" \
              --wrong-text="Fail" \
              --verif-color=$TEXT_COLOR \
              --wrong-color=$TEXT_COLOR \
              --{time,date,layout,verif,wrong,greeter}-font=$TEXT_FONT

