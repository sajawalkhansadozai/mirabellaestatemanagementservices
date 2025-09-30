// ===============================
// File: lib/models/models.dart
// Plain Dart models for app data
// ===============================
import 'package:flutter/foundation.dart';

/// Service offered (icon chosen at render time)
@immutable
class Service {
  final String title;
  final String description;
  final List<String> features;

  const Service({
    required this.title,
    required this.description,
    required this.features,
  });
}

/// Property listing (amenities, specs, pricing)
@immutable
class Property {
  final String image; // network image url
  final String title;
  final String location;
  final String price; // e.g., "PKR 45,000"
  final String period; // e.g., "month"
  final String type; // Residential / Commercial
  final int? beds; // null if N/A (e.g., office/retail)
  final int baths;
  final String area; // e.g., "5000 sq ft"
  final String status; // Available / Rented
  final List<String> amenities;

  const Property({
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    required this.period,
    required this.type,
    required this.beds,
    required this.baths,
    required this.area,
    required this.status,
    required this.amenities,
  });
}

/// Client testimonial
@immutable
class Testimonial {
  final String name;
  final String role;
  final String image; // avatar URL
  final String text;
  final int rating; // 1..5
  final String location;

  const Testimonial({
    required this.name,
    required this.role,
    required this.image,
    required this.text,
    required this.rating,
    required this.location,
  });
}

/// KPI/stat strip item
@immutable
class StatItem {
  final String number; // e.g., "500+"
  final String label; // e.g., "Properties Managed"
  final String subtext; // e.g., "Across Islamabad & Rawalpindi"

  const StatItem({
    required this.number,
    required this.label,
    required this.subtext,
  });
}

/// Why-choose-us feature point
@immutable
class WhyUsItem {
  final String title;
  final String description;

  const WhyUsItem({required this.title, required this.description});
}

/// Process step (01..06)
@immutable
class ProcessStepItem {
  final String step; // "01"
  final String title; // "Initial Consultation"
  final String description;

  const ProcessStepItem({
    required this.step,
    required this.title,
    required this.description,
  });
}

/// FAQ item
@immutable
class FAQItem {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});
}

/// Pricing plan
@immutable
class PricingPlan {
  final String name; // "Basic", "Professional", "Premium"
  final String price; // "8%"
  final String period; // "of monthly rent"
  final String description;
  final List<String> features;
  final bool popular;

  const PricingPlan({
    required this.name,
    required this.price,
    required this.period,
    required this.description,
    required this.features,
    required this.popular,
  });
}
