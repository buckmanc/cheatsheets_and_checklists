# BASH

## extract filename parts

[source](https://stackoverflow.com/a/965069)

```bash

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

## check for program
```bash
if (! type 7z > /dev/null 2>&1 )
then
    echo "7zip not installed"
fi
```
