#!/bin/bash

# RoadSurfer Web App Deployment Script
echo "🚀 Deploying RoadSurfer to GitHub Pages..."

# Build the web app
echo "📦 Building web app..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Create a temporary directory for deployment
    echo "📁 Preparing deployment..."
    rm -rf deploy
    mkdir deploy
    cp -r build/web/* deploy/
    
    # Create a simple index.html redirect if needed
    echo "🔗 Creating deployment files..."
    
    echo "✅ Deployment files ready!"
    echo "📋 Next steps:"
    echo "1. Go to your GitHub repository settings"
    echo "2. Navigate to 'Pages' section"
    echo "3. Set source to 'Deploy from a branch'"
    echo "4. Select 'gh-pages' branch and '/ (root)' folder"
    echo "5. Save the settings"
    echo ""
    echo "🌐 Your app will be available at: https://fahadkhalid.github.io/RoadSurfer/"
    
else
    echo "❌ Build failed!"
    exit 1
fi 