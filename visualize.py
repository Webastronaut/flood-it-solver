#!/usr/bin/python3
from __future__ import print_function
from sys import argv, exit
from re import findall, finditer, sub, MULTILINE
from time import sleep
import subprocess

# max size of board is 30x30
max_size = 30
# create basic grid
grid = [[0 for x in range(max_size)] for y in range(max_size)]
# final board
c = []
seq = []
step = 0

# set cell values
def cell(x,y,cl,update=False):
    global c, grid
    x-=1
    y-=1

    # update=true means the flood grows, we want to highlight the cells which are
    # part of the flood, otherwise we print out the number as is
    if update or (x==0 and y==0):
        grid[x][y] = '\u001b[7m' + str(cl) + '\u001b[0m'
    else:
        grid[x][y] = str(cl)

# shrink grid to actual size
def clean_board():
    global c, grid
    for i in range(0, max_size):
        # first item in row not equals zero? add it to the board
        if grid[i][0] != 0:
            c.append(grid[i])
            # remove zeroed items from board (no zero values allowed)
            while c[i][-1] == 0:
                c[i].pop()

# print out board (simple matrix printing)
def print_board():
    for i in range(0, len(c)):
        for j in range(0, len(c)):
            print(c[i][j], end=" ")
        print()
    print()

# update board based on telingo solution
def process_output(s):
    global output, c, seq, step
    
    state = findall("State[0-9]+", s)[0]
    state = findall("([0-9]+)", state)[0]
    color = findall("choose\([0-9]+\)", s)[0]
    color = findall("([0-9]+)", color)[0]

    s = sub("State[0-9]+", "", s)
    s = sub("choose\([0-9]+\)", "", s)
    s = sub("c", " c", s)
    s = sub(",[0-9]+\)", ")", s)

    if step > 0:
        seq.append(color)
    
    if step > 0:
        print("State %s -> Choose %s:" % (state, color))
    else:
        print("State %s:" % state)

    for i in range(1, len(c)+1):
        for j in range(1, len(c)+1):
            c_str = "c(" + str(i) + "," + str(j) + ")"

            if c_str not in s:
                cell(i,j,color,update=True)

    step += 1
        
    print_board()

# fill cells with values from instance file
def create_cell(s):
    res = findall(r'[0-9]+', s)
    if len(res) == 3:
        cell(int(res[0]), int(res[1]), int(res[2]))

if len(argv) <= 1:
    print("Error: No instance specified.")
    exit(1)
else:
    instance = argv[1]

    with open(instance) as f:
        for line in f:
            create_cell(line)
        
clean_board()

cmd = subprocess.Popen(["telingo", "floodit.lp", instance, "1"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
print("Solving ...")
            
# run command and save output and error msg
stdout, stderr = cmd.communicate()

if stderr == None:
    output = stdout.decode("utf-8")
    
    res = findall(r'(\s{1}State\s[0-9]+:\n\s\schoose\([0-9]+\)\n\s?(\sc\([0-9]+,[0-9]+,[0-9]+\))*)', output, flags=MULTILINE)

    for match in res:
        match = sub('\n|:|\s', '', match[0])
        process_output(match)
        sleep(2)

    print("Color sequence: ", end="")
    print(seq)
else:
    print(stderr)
