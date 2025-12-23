# Add to .gitignore if not already present
if ! grep -q "^\\.env$" .gitignore; then
  echo ".env" >> .gitignore
  echo "✓ Added .env to .gitignore"
else
  echo "✓ .env already in .gitignore"
fi
