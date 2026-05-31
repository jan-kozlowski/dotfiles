#!/usr/bin/env bash

BG_DIR="$HOME/.config/omarchy/backgrounds"
STATE_FILE="$HOME/.local/share/theme-rotate-state"

# Zbuduj listę theme (posortowana, deterministyczna)
THEME_DIRS=()
while IFS= read -r dir; do
    THEME_DIRS+=("$(basename "$dir")")
done < <(find "$BG_DIR" -mindepth 1 -maxdepth 1 -type d | sort)

# Odczytaj state: aktualny theme index + bg index
LAST_THEME_INDEX=$(grep "^theme_index=" "$STATE_FILE" 2>/dev/null | cut -d= -f2)
LAST_BG_INDEX=$(grep "^bg_index=" "$STATE_FILE" 2>/dev/null | cut -d= -f2)
LAST_THEME_INDEX=${LAST_THEME_INDEX:-0}
LAST_BG_INDEX=${LAST_BG_INDEX:-0}

THEME_DIR="${THEME_DIRS[$LAST_THEME_INDEX]}"
BACKGROUNDS=($(find "$BG_DIR/$THEME_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort))

# Następny bg index
NEXT_BG_INDEX=$((LAST_BG_INDEX + 1))

if [[ $NEXT_BG_INDEX -ge ${#BACKGROUNDS[@]} ]]; then
    # Wyczerpano backgroundy — przejdź do kolejnego theme
    NEXT_BG_INDEX=0
    NEXT_THEME_INDEX=$(( (LAST_THEME_INDEX + 1) % ${#THEME_DIRS[@]} ))
    THEME_DIR="${THEME_DIRS[$NEXT_THEME_INDEX]}"
    BACKGROUNDS=($(find "$BG_DIR/$THEME_DIR" -maxdepth 1 -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort))
else
    NEXT_THEME_INDEX=$LAST_THEME_INDEX
fi

BG="${BACKGROUNDS[$NEXT_BG_INDEX]}"
THEME_NAME=$(echo "$THEME_DIR" | sed 's/-/ /g; s/\b\(.\)/\u\1/g')

# Zapisz state
cat > "$STATE_FILE" <<EOF
theme_index=$NEXT_THEME_INDEX
bg_index=$NEXT_BG_INDEX
EOF

omarchy theme set "$THEME_NAME"
