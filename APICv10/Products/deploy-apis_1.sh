#!/bin/bash


echo "Usage : deploy-apis.sh to publish apis"

#product=ibm-auto-product_1.0.0

prop_location="${builddir}/${clientdir}/${vendor_name}/${API_name}"

echo $prop_location
readarray -t props_arr <<< $(ls "$prop_location")
mkdir -p target/apis
for f in "${props_arr[@]}"; 
do
   if [[ $f =~ ibm-auto-product_1.0.0\.yaml ]]; then 
	   echo "$f"
	   cp -r $prop_location/$f target/apis
   fi
done

echo "Product name is $product"

cd target/apis
readarray -t prop_arr <<< $(ls )
for yamlfile in "${prop_arr[@]}"; 
do
   echo "APIs to deploy: the file name is $yamlfile"
   echo "Catalogue name is $apic_catalog"
   #apic draft-apis:create --accept-license "$yamlfile" --server "$apic_server_name" --org "$apic_org_name"
   product=$(echo $yamlfile)

   echo "Product name is $product"
   #rm -rf "$product".yaml
   #apic create:product --accept-license --title "$product" --apis "$yamlfile"
   #apic draft-products:create --accept-license "$product".yaml --server "$apic_server_name" --org "$apic_org_name"
   apic login --accept-license -s "$apic_server_name" -r "$apic_realm" -u "$apic_username" -p "$apic_password"
   echo "apic products publish $product.yaml -c $apic_catalog --server $apic_server_name --org $apic_org_name"
   apic products publish --accept-license "$product".yaml -c "$apic_catalog" --server "$apic_server_name" --org "$apic_org_name"
   
done

# apic login --accept-license -s "$apic_server_name" -r "$apic_realm" -u "$apic_username" -p "$apic_password"
# # apic create:product --accept-license --title "$product" --apis "$yamlfile"
# # apic draft-products:create --accept-license "$product".yaml --server "$apic_server_name" --org "$apic_org_name"
# echo "apic products publish $product.yaml -c $apic_catalog --server $apic_server_name --org $apic_org_name"
# apic products publish --accept-license "$product".yaml -c "$apic_catalog" --server "$apic_server_name" --org "$apic_org_name"
