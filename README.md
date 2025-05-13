# es2idl : A script to generate WebIDL definition for the ECMAScript built-ins

This is a prototype for demonstrating and exploring the representation the ECMAScript Language Specification's built-ins with WebIDL.

## Run

Running the following command will create a virtualenv, download the specs, and generate the WebIDL files.

```
./generate.sh
```


The specs are downloaded in `specs/` directory, and the generated files are located in `output/`, with the following names:
  * `SpecNew.webidl` : Utilizes newly-introduced syntax to represent ECMAScript-specific characteristics
  * `SpecNewType.webidl` : Utilizes newly-introduced syntax and experimental parameter types to represent ECMAScript-specific characteristics
  * `SpecCompat.webidl` : Utilizes extended attributes to represent ECMAScript-specific characteristics

Passing `--cached` skips the preparation such as downloading the specs.

```
./generate.sh --cached
```
