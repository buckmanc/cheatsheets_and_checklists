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

## count args
```bash
echo "$#"
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

## iterate lines
```bash
while read -r line
do
    echo "$line"
done < <(echo "$lines")
```

## substring
```bash
# ${string:offset:length}

var="hello world"
echo "${var:0:5} bob"
```

## move to beginning and clear line
```bash
echo -ne "\r\033[2K task x% done"
```

## date gate
```bash
if [[ "$(date '+%s')" -lt "$(date --date '2552-09-28' '+%s')" ]]
then
	echo 'skippy skippy'
	exit 0
fi
```

## test operators

operator|desc
---|---
`-eq`| equal to
`-gt`| greater than
`-ge`| greater than or equal to
`-lt`| less than
`-le`| less than or equal to
`-f`|file exists
`-d`|directory exists
`-e`|anything exists
`-x`|file is executable
`-ef`|file path equals
`-n`|string is not empty
`-z`|string is empty

## using operators
```bash
if [[ "$var" -gt 0 ]]
then
    echo "yep it's greater than zero"
fi

if test "$var" -gt 0
then
    echo "yep it's greater than zero"
fi
```
