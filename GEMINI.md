To ensure Gemini CLI or any AI assistant has a complete "mental model" of your project, you should provide this structured technical documentation. It combines the architecture, the specific logic we've written together, and the database state.

Copy and paste the block below:

Project Identity: EcoTISB
System Purpose: A sustainable, circular-economy marketplace for The International School Bangalore (TISB). Goal: Enable students to list, swap, and give away school essentials (textbooks, uniforms, etc.) while earning "Eco-Points."

1. Technical Stack
   Frontend: Flutter (v3.22+ compatible) using Material 3.

Backend: Supabase (PostgreSQL + Auth + Storage).

State Management: StatefulWidget with service-level abstraction.

Key Plugins: * supabase_flutter: Backend integration.

image_picker: For listing photos.

path: For file extension handling during uploads.

2. Database & Storage Architecture
   Profiles Table
   Links to Supabase Auth. We use Email as the primary relational key for simplified lookup.

SQL

CREATE TABLE public.profiles (
email TEXT PRIMARY KEY,
full_name TEXT NOT NULL,
points INT4 DEFAULT 0,
avatar_url TEXT,
created_at TIMESTAMPTZ DEFAULT NOW()
);
Items Table
The core marketplace data.

SQL

CREATE TABLE public.items (
id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
seller_email TEXT REFERENCES public.profiles(email),
title TEXT NOT NULL,
description TEXT, -- Often formatted as "Grade: X | Real Description"
category TEXT,
condition_rating INT4 DEFAULT 3, -- 1 (Poor) to 5 (New)
image_url TEXT,
is_swapped BOOLEAN DEFAULT false,
created_at TIMESTAMPTZ DEFAULT NOW()
);
Storage (Supabase Storage)
Bucket Name: item_images

Access: Public Read (RLS Select enabled).

Pathing: public/timestamp_filename.ext.

3. Core Logic & Implementation Details
   Listing Items (ListItemScreen)
   Image Workflow: Uses image_picker to select a local file, uploads to item_images via SupabaseService.uploadItemImage, and receives a public URL before creating the database row.

Data Transformation: UI condition strings (e.g., "Like New") are mapped to int ratings (4) before insertion.

Marketplace Feed (MarketplaceScreen)
Feed Logic: Fetches items via _supabaseService.getAvailableItems().

Navigation: Uses dynamic MaterialPageRoute to pass the full Item object to the ItemDetailsScreen.

Components: Uses ItemCard which handles Image.network with loadingBuilder and errorBuilder.

Details Screen (ItemDetailsScreen)
Relationship Loading: On initState, it fetches the UserProfile of the seller based on the item's seller_email.

UI Features: Displays badges for category and grade, an "Eco Impact" card (CO2 savings), and seller reputation (points).

4. Current File Structure
   lib/models/item.dart: JSON serialization and UI-friendly getters (e.g., conditionString).

lib/models/user_profile.dart: Maps profile data from the DB.

lib/services/supabase_service.dart: Singleton handling all API calls.

lib/screens/: Contains marketplace_screen.dart, list_item_screen.dart, and item_details_screen.dart.

lib/utils/colors.dart: Centralized theme using AppColors.

5. Active Conventions
   Deprecation Handling: Using .withValues(alpha: 0.1) instead of .withOpacity().

Error Handling: All async calls wrap in try-catch with ScaffoldMessenger feedback.

Null Safety: Strict null-checking on user emails and image URLs.

Next high-priority tasks:


Implement "Mark as Swapped" logic to remove items from the feed.

Establish internal Messaging/Chat.