#!/bin/sh
cd _build/default/lib/etssandbox/ebin/
erl -pa ebin -eval "application:start(etssandbox)"
