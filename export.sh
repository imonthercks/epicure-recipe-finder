


 awk '{
    for (i=1; i<=NF; i++) {
        if ($i ~ /^https:\/\/epicure\.com\/en-us\/recipe\//) {
            split($i, parts, "/");
            last_segment = parts[length(parts)];
            recipe_name = last_segment;
            gsub("-", " ", recipe_name);  # Replace hyphens with spaces
            # Exclude lines with extensions or containing "http"/"https" within the URL
            if ($i ~ /\.(jpg|png|pdf|html)$/ || $i ~ /http[^s]:/ || $i ~ /https[^:]/) {
                next;
            }
            if (!seen[$i] || $(i-1) > seen[$i]) {
                seen[$i] = $(i-1);
                data[$i] = "{\"url\": \"" $i "\", \"snapshot_date\": \"" $(i-1) "\", \"last_segment\": \"" last_segment "\", \"recipe_name\": \"" recipe_name "\"}";
            }
        }
    }
} END {
    for (url in data) {
        print data[url];
    }
}' url_logs.txt | jq -s '.' > extracted_urls.json