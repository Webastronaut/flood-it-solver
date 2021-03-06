# flood-it-solver
Flood-It solver written for the ASP system [telingo](https://github.com/potassco/telingo).

## Usage

### Create test instances

Run the following command:

```shell
./create-instance [NUMBER_OF_ROWS] [NUMBER_OF_COLORS]
```

For example

```shell
./create-instance 12 4
```

would create the file *./instances/flood-it-board-12x12-4.lp*.

### Run solver on instances

Install telingo, change to the directory of the downloaded flood-it-solver and then type (all via command line):

```shell
telingo floodit.lp instances/flood-it-board-12x12-4.lp 1 --stats
```

### Visualize solution

To see a rudimentary visualization of the first found solution run the following command (works only with python 3.x):

```shell
python visualize.py [INSTANCE_FILE]
```

For example:

```shell
python visualize.py instances/flood-it-board-12x12-4.lp
```
