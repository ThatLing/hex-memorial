
# Synchronous GMod serial (COM, RS232) communication module #
##### This was more annoying that it should have been #####

See the example script.

* * *

Open, Use 1 for both if you don't want the main thread blocked.
```
serial.Open("COM2", read_timeout, write_timeout)
```


Close, returns nil
```
serial.Close()
```



IsValid, returns bool if port is ok
```
serial.IsValid()
```



Read, returns string of num_bytes
```
serial.Read(num_bytes)
```



Write, returns nil
```
serial.Write(str)
```


























