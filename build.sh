
nasm -felf64 -o game.o game.asm &&
gcc -o game game.o -lc -no-pie &&
./game &&
rm game 
