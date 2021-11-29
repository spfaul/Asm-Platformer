
nasm -felf64 -o game.o game.asm &&
gcc -m64 -o game game.o -lc -no-pie &&
./game
