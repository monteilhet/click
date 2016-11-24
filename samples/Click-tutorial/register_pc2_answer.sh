#!/bin/bash

data=${1-'OOOO|AAAA'}

export HOST=localhost
export PORT=3333
export HANDLER_NAME=h_map
export SHORT_NAME=DummyAnswer

./add_handler_mapping.sh $data

