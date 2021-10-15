#!/bin/bash

grep chrX 225.bedGRaph | awk 'BEGIN {bases = 0} \
			     {if($2>=15578261 && $3<=15621068) bases = bases + ($3-$2)} \
			     END { print bases " bases (" 100*(bases/(15621068-15578261)) "% coverage)" }'

grep chrX 225.bedGRaph | awk 'BEGIN {units=0} {if($2>=15578261 && $3<=15621068) units = units + (($3-$2)/30)} END{print units " units"}'


grep chrX 225.test5.bedGRaph | awk 'BEGIN {bases = 0} \
			     {if($2>=15578261 && $3<=15621068) bases = bases + ($3-$2)} \
			     END { print bases " bases (" 100*(bases/(15621068-15578261)) "% coverage)" }'


