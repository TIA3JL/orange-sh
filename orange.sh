mark=5 # number of asterisks
sym="ó"
edSym="*"

main()
{
	# terminal sizes
	xSize=$(tput cols)
	ySize=$(tput lines)

	xCenter=$((xSize / 2))
	yCenter=$((ySize / 2))

	x=$xCenter
	y=$yCenter

	declare -A arr

	for arg in "$@"; do
		case $arg in
			--help|-h) msg 3 ;;
			--about|-a) msg 2 ;;
			*) printf "Unknown argument: $arg\n" && exit ;;
		esac
	done

	wInit
	quitHandler

	mkEds $mark

	for ((;;))
	{
		(( mark == score )) && msg 1

		drawHud
		drawEds
		collision
		drawPointer
		inputHandler
	}
	return 0
}

# GAME MECHANICS

mkEds()
{
	# $1: generate edibles with random x, y
	local count=$1

	for ((i=0;i<count;i++)); do
		local x=$(genRandom "$xSize")
		local y=$(genRandom "$ySize" - 1)
		arr["$y;$x"]=1
	done
}

collision()
{
	eval "
	case \"\$y;\$x\" in
		$(for i in "${!arr[@]}"; do
			echo "\"$i\") unset arr\[\"$i\"\] && (( score++ )) ;;"
		done)
	esac
	"
}

drawHud(){ printf "\e[999Hscore=%d" "$score"; }

drawPointer() { printf "\e[%d;%dH%s" "$y" "$x" "$sym"; }

drawEds()
{
	for i in "${!arr[@]}"; do
		(( ${arr[$i]} )) && printf "\e[%sH%s" "$i" "$edSym"
	done
}

# TERMINAL ONLY

wInit() { stty -icanon -echo && printf "\e[33m\e[2J\e[?25l"; }

restoreTerm() { stty icanon echo && clear && printf "\e[?25h\e[0m" && exit; }

quitHandler() { trap 'restoreTerm' EXIT && trap 'restoreTerm' SIGWINCH; }

inputHandler()
{
	read -rsn1 key

	case $key in
		w|k) (( $y - 1 > 0 )) && (( y-- )) && printf "\e[2J" ;;
		a|h) (( $x - 1 > 0 )) && (( x-- )) && printf "\e[2J" ;;
		s|j) (( $y < $ySize )) && (( y++ )) && printf "\e[2J" ;;
		d|l) (( $x < $xSize )) && (( x++ )) && printf "\e[2J" ;;
		q) exit ;;
	esac
}

# ADDITIONAL THINGS

genRandom()
{
	# $1: maximum random value
	local min=1 max=$1
	echo $(( min + RANDOM % (max - min + 1) ))
}

help="Usage: orange.sh [options]

A trivial asterisk eating game where you are an orange.

Options:
  --help    display this message and exit
  --about   little story about this game

Notice:
  If you want to change the size of the terminal during the game, the game will close.
  Pay attention to the settings at the beginning of the sh file. You can eat more asterisks if you wish!

github.com/everydayikillmylinux
"

msg()
{
	# $1: message type to output
	(( $1 == 1 )) &&
	{
		for (( i=0; i<20;i++ )); do
			printf "\e[%sm" "$(( 32 + i % 2 * 58 ))"
			printf "\e[%d;%dH%s" "$yCenter" "$xCenter" "WIN!"
			sleep 0.1
		done
		exit
	}
	(( $1 == 2 )) && drawAsciiArt && exit
	(( $1 == 3 )) && printf "$help" && exit
}

drawAsciiArt()
{
	printf "\e[33m"
	cat << "EOF"
mark=5 # number of asterisks
sym="ó"
edSym="*"

main()
{
	# terminal sizes
	xSize=$(tput cols)
	ySize=$(tput lines)

	xCenter=$((xSize / 2))
	yCenter=$((ySize / 2))

	x=$xCenter
	y=$yCenter

	declare -A arr

	for arg in "$@"; do
		case $arg in
			--help|-h) msg 3 ;;
			--about|-a) msg 2 ;;
			*) printf "Unknown argument: $arg\n" && exit ;;
		esac
	done

	wInit
	quitHandler

	mkEds $mark

	for ((;;))
	{
		(( mark == score )) && msg 1

		drawHud
		drawEds
		collision
		drawPointer
		inputHandler
	}
	return 0
}

# GAME MECHANICS

mkEds()
{
	# $1: generate edibles with random x, y
	local count=$1

	for ((i=0;i<count;i++)); do
		local x=$(genRandom "$xSize")
		local y=$(genRandom "$ySize" - 1)
		arr["$y;$x"]=1
	done
}

collision()
{
	eval "
	case \"\$y;\$x\" in
		$(for i in "${!arr[@]}"; do
			echo "\"$i\") unset arr\[\"$i\"\] && (( score++ )) ;;"
		done)
	esac
	"
}

drawHud(){ printf "\e[999Hscore=%d" "$score"; }

drawPointer() { printf "\e[%d;%dH%s" "$y" "$x" "$sym"; }

drawEds()
{
	for i in "${!arr[@]}"; do
		(( ${arr[$i]} )) && printf "\e[%sH%s" "$i" "$edSym"
	done
}

# TERMINAL ONLY

wInit() { stty -icanon -echo && printf "\e[33m\e[2J\e[?25l"; }

restoreTerm() { stty icanon echo && clear && printf "\e[?25h\e[0m" && exit; }

quitHandler() { trap 'restoreTerm' EXIT && trap 'restoreTerm' SIGWINCH; }

inputHandler()
{
	read -rsn1 key

	case $key in
		w|k) (( $y - 1 > 0 )) && (( y-- )) && printf "\e[2J" ;;
		a|h) (( $x - 1 > 0 )) && (( x-- )) && printf "\e[2J" ;;
		s|j) (( $y < $ySize )) && (( y++ )) && printf "\e[2J" ;;
		d|l) (( $x < $xSize )) && (( x++ )) && printf "\e[2J" ;;
		q) exit ;;
	esac
}

# ADDITIONAL THINGS

genRandom()
{
	# $1: maximum random value
	local min=1 max=$1
	echo $(( min + RANDOM % (max - min + 1) ))
}

help="Usage: orange.sh [options]

A trivial asterisk eating game where you are an orange.

Options:
  --help    display this message and exit
  --about   little story about this game

Notice:
  If you want to change the size of the terminal during the game, the game will close.
  Pay attention to the settings at the beginning of the sh file. You can eat more asterisks if you wish!

github.com/everydayikillmylinux
"

msg()
{
	# $1: message type to output
	(( $1 == 1 )) &&
	{
		for (( i=0; i<20;i++ )); do
			printf "\e[%sm" "$(( 32 + i % 2 * 58 ))"
			printf "\e[%d;%dH%s" "$yCenter" "$xCenter" "WIN!"
			sleep 0.1
		done
		exit
	}
	(( $1 == 2 )) && drawAsciiArt && exit
	(( $1 == 3 )) && printf "$help" && exit
}

drawAsciiArt()
{
	printf "\e[33m"
	cat << "EOF"
                 ___          ,
                 `  `--.    ,'
                  `.    \  /    |
                    `-.._\/    .|/
                         /   ---X--
                         |     /|`
                   _,--''''-..  |
                 ,'           `.
                /               `.
               /                  \
              |                    |
              |                    |
              |                    |
              |                    |
               \                  /
               '.                /
                 `.            ,'
                   `.._ __ _,-'
.------------------------------------------------.
|         The Garden of Terminal Symbols.        |
|Today's the harvest and Orange are getting ready|
|       for being plucked from the branch.       |
|    Collect special dust "asterisk" to grow.    |
|       Become the most attractive orange        |
|            in the world of symbols!            |
`------------------------------------------------'
EOF
	printf "\e[0m"
}

main "$@"

EOF
	printf "\e[0m"
}

main "$@"
