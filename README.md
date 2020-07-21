# 4d-tips-create-constants-hash-table
Resolve constant name from value

#### Usage

```4d
$constant:=$constants["Events (Modifiers)"]["256"] //"Command key mask"
```

Takes into account that...

* constant value type can be string (``([^:]+):S``), numeric (``([^:]+):L|R``) or implicit
* some constants are missing (``87_6``, ``81_304``, etc.)
