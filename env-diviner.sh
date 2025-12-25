#!/usr/bin/env bash
# Env Variable Diviner - Because your config shouldn't be a mystery
# Summons the spirits of .env files past to reveal what's missing

# Colors for dramatic effect (like a real divination)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (the spirits have left)

# The sacred texts (sample .env files)
SAMPLE_FILES=(".env.example" ".env.sample" "env.example" "sample.env")

# The actual prophecy (.env file)
ACTUAL_FILE=".env"

# Find the most holy sample file
find_sample_file() {
    for file in "${SAMPLE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            echo "$file"
            return 0
        fi
    done
    return 1
}

# Main ritual
main() {
    echo -e "${YELLOW}🔮 Consulting the environmental spirits...${NC}"
    echo
    
    SAMPLE=$(find_sample_file)
    
    if [[ -z "$SAMPLE" ]]; then
        echo -e "${RED}✗ No sample .env file found! The spirits are confused.${NC}"
        echo "Looked for: ${SAMPLE_FILES[*]}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Found sacred text: $SAMPLE${NC}"
    
    if [[ ! -f "$ACTUAL_FILE" ]]; then
        echo -e "${RED}✗ No .env file found! The prophecy remains unwritten.${NC}"
        echo -e "${YELLOW}📜 Here's what you're missing:${NC}"
        cat "$SAMPLE"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Found prophecy: $ACTUAL_FILE${NC}"
    echo
    
    # Compare the sacred texts
    MISSING_VARS=0
    
    while IFS='=' read -r var _; do
        # Skip comments and empty lines
        if [[ -n "$var" && ! "$var" =~ ^# ]]; then
            if ! grep -q "^$var=" "$ACTUAL_FILE" 2>/dev/null; then
                if [[ $MISSING_VARS -eq 0 ]]; then
                    echo -e "${YELLOW}⚠️  The spirits reveal missing variables:${NC}"
                fi
                echo -e "  ${RED}✗${NC} $var"
                ((MISSING_VARS++))
            fi
        fi
    done < "$SAMPLE"
    
    if [[ $MISSING_VARS -eq 0 ]]; then
        echo -e "${GREEN}✅ All variables present! The environment is harmonious.${NC}"
    else
        echo -e "\n${YELLOW}$MISSING_VARS variable(s) missing from $ACTUAL_FILE${NC}"
        exit 1
    fi
}

# Invoke the ritual
main "$@"
