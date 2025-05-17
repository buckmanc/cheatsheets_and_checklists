# Bash

## extract filename parts

[source](https://stackoverflow.com/a/965069)

```bash
~% FILE="example.tar.gz"

~% echo "${FILE%%.*}"
example

~% echo "${FILE%.*}"
example.tar

~% echo "${FILE#*.}"
tar.gz

~% echo "${FILE##*.}"
gz
```

## uppercase var
```bash
echo "${var^^}"
```

## lowercase var
```bash
echo "${var,,}"
```

## increment var
```bash
i=$((i+1))
```

## native regex
```bash
if [[ "$var" =~ [0-9]{3} ]]
then
    echo 'it matches'
fi
```

## count args
```bash
echo "$#"
```

## print line number
```bash
echo "$LINENO"
```

## clear starship error code
```bash
true
```

## check for program
```bash
if (! type 7z > /dev/null 2>&1 )
then
    echo "7zip not installed"
fi
```

## assign to an array
```bash
myArray=() 
myArray+=("$var")
```

## count array elements
```bash
echo "array has ${#myArray[@]} items"
```

## iterate an array
```bash
for var in "${myArray[@]}"
do
  echo "$var"
done
```

## iterate args
```bash
for arg in "$@"
do
    echo "$arg"
done
```

## date gate
```bash
if [[ "$(date '+%s')" -lt "$(date --date '2552-09-28' '+%s')" ]]
then
	echo 'skippy skippy'
	exit 0
fi
```
