
nasm -felf64 -o game.o game.asm &&
ld -o game game.o &&
./game &&
rm game 
