#!/bin/bash


echo "Usage : deploy-apis.sh to publish apis"

product=ramp-auto-product101

echo "Product name is $product"

apic login --accept-license -s "$apic_server_name" -r "$apic_realm" -u "$apic_username" -p "$apic_password"
# apic create:product --accept-license --title "$product" --apis "$yamlfile"
# apic draft-products:create --accept-license "$product".yaml --server "$apic_server_name" --org "$apic_org_name"
echo "apic products publish $product.yaml -c $apic_catalog --server $apic_server_name --org $apic_org_name"
apic products publish --accept-license "$product".yaml -c "$apic_catalog" --server "$apic_server_name" --org "$apic_org_name"
