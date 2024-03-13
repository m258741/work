JSONFILE=$1
#
# ORIG:
#cat $JSONFILE | jq --argjson bomRefs '["3da74674-ee51-4d6c-bca8-197de40f6d21", "another-bom-ref-value"]' '.[] | select(.metadata.component."bom-ref" as $bomref | $bomRefs | index($bomref) // false) | .metadata.component.bom-ref'

# WORKS:
#cat $JSONFILE | jq --argjson bomRefs '["3da74674-ee51-4d6c-bca8-197de40f6d21", "another-bom-ref-value"]' '.[] | select(.metadata.component."bom-ref" as $bomref | $bomRefs | index($bomref) // false) '

set -x

jq --argfile bomRefsFile bom_refs.txt '.[] | select(.metadata.component."bom-ref" as $bomref | $bomRefsFile | index($bomref) // false) ' $JSONFILE


