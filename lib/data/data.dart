// ===============================
// File: lib/data/data.dart
// App data (converted 1:1 from React)
// ===============================
import '../models/models.dart';

/// Services
const List<Service> servicesData = [
  Service(
    title: 'Residential Property Management',
    description:
        'Complete end-to-end management of residential properties including apartments, houses, and villas.',
    features: [
      '24/7 Emergency Response',
      'Tenant Screening & Placement',
      'Rent Collection & Financial Reports',
      'Regular Property Inspections',
      'Maintenance Coordination',
      'Legal Compliance Management',
    ],
  ),
  Service(
    title: 'Commercial Property Management',
    description:
        'Specialized management services for offices, retail spaces, and commercial complexes.',
    features: [
      'Lease Negotiation & Management',
      'Facility Management',
      'Vendor Coordination',
      'Security Management',
      'Common Area Maintenance',
      'Financial Reporting & Analysis',
    ],
  ),
  Service(
    title: 'Rental & Leasing Services',
    description:
        'Professional tenant placement and comprehensive lease management solutions.',
    features: [
      'Property Marketing & Advertising',
      'Tenant Background Checks',
      'Lease Agreement Preparation',
      'Move-in/Move-out Inspections',
      'Security Deposit Management',
      'Renewal Negotiations',
    ],
  ),
  Service(
    title: 'Maintenance & Repairs',
    description:
        'Proactive maintenance programs to keep your property in excellent condition.',
    features: [
      'Preventive Maintenance Plans',
      'Emergency Repair Services',
      'Vendor Management',
      'Quality Assurance',
      'Cost-Effective Solutions',
      'Detailed Maintenance Records',
    ],
  ),
  Service(
    title: 'Tenant Relations & Support',
    description:
        'Professional tenant management ensuring positive landlord-tenant relationships.',
    features: [
      '24/7 Tenant Support',
      'Complaint Resolution',
      'Lease Enforcement',
      'Communication Management',
      'Conflict Mediation',
      'Tenant Retention Programs',
    ],
  ),
  Service(
    title: 'Financial Management',
    description:
        'Comprehensive financial services to maximize your property investment returns.',
    features: [
      'Monthly Financial Reports',
      'Budget Planning & Analysis',
      'Rent Collection & Processing',
      'Tax Documentation',
      'Expense Tracking',
      'ROI Optimization',
    ],
  ),
  Service(
    title: 'Legal & Compliance',
    description:
        'Expert handling of all legal aspects and regulatory compliance matters.',
    features: [
      'Legal Documentation',
      'Regulatory Compliance',
      'Eviction Processing',
      'Dispute Resolution',
      'Contract Management',
      'Risk Management',
    ],
  ),
  Service(
    title: 'Property Consulting',
    description:
        'Strategic consulting services to enhance property value and investment returns.',
    features: [
      'Market Analysis',
      'Investment Advisory',
      'Property Valuation',
      'Renovation Guidance',
      'Portfolio Management',
      'Exit Strategy Planning',
    ],
  ),
];

/// Properties
const List<Property> propertiesData = [
  Property(
    image: 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
    title: 'Executive Luxury Villa',
    location: 'DHA Phase 6, Islamabad',
    price: 'PKR 45,000',
    period: 'month',
    type: 'Residential',
    beds: 5,
    baths: 6,
    area: '5000 sq ft',
    status: 'Available',
    amenities: ['Swimming Pool', 'Garden', 'Parking', 'Security'],
  ),
  Property(
    image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
    title: 'Modern Penthouse',
    location: 'Bahria Town Phase 4, Islamabad',
    price: 'PKR 35,000',
    period: 'month',
    type: 'Residential',
    beds: 3,
    baths: 3,
    area: '2500 sq ft',
    status: 'Available',
    amenities: ['Gym', 'Rooftop', 'Parking', 'Elevator'],
  ),
  Property(
    image: 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=800',
    title: 'Premium Office Space',
    location: 'F-7 Markaz, Islamabad',
    price: 'PKR 80,000',
    period: 'month',
    type: 'Commercial',
    beds: null,
    baths: 2,
    area: '3000 sq ft',
    status: 'Available',
    amenities: ['AC', 'Conference Room', 'Parking', 'Cafeteria'],
  ),
  Property(
    image: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
    title: 'Contemporary Apartment',
    location: 'E-11, Islamabad',
    price: 'PKR 28,000',
    period: 'month',
    type: 'Residential',
    beds: 2,
    baths: 2,
    area: '1400 sq ft',
    status: 'Available',
    amenities: ['Balcony', 'Parking', 'Security', 'Playground'],
  ),
  Property(
    image: 'https://images.unsplash.com/photo-1582407947304-fd86f028f716?w=800',
    title: 'Retail Shop Space',
    location: 'Blue Area, Islamabad',
    price: 'PKR 65,000',
    period: 'month',
    type: 'Commercial',
    beds: null,
    baths: 1,
    area: '1800 sq ft',
    status: 'Available',
    amenities: ['Prime Location', 'Glass Facade', 'Parking', 'Storage'],
  ),
  Property(
    image: 'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
    title: 'Spacious Family Home',
    location: 'G-13, Islamabad',
    price: 'PKR 38,000',
    period: 'month',
    type: 'Residential',
    beds: 4,
    baths: 4,
    area: '3200 sq ft',
    status: 'Rented',
    amenities: ['Garden', 'Garage', 'Modern Kitchen', 'Security'],
  ),
];

/// Testimonials
const List<Testimonial> testimonialsData = [
  Testimonial(
    name: 'Ahmed Hassan',
    role: 'Property Owner - 8 Properties',
    image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    text:
        'Mirabella has been managing my properties for over 2 years. Their professionalism, transparency, and attention to detail is outstanding! My rental income has increased by 25% since I started working with them.',
    rating: 5,
    location: 'DHA, Islamabad',
  ),
  Testimonial(
    name: 'Fatima Khan',
    role: 'Real Estate Investor',
    image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    text:
        'Best property management service in Islamabad. They handle everything efficiently from tenant screening to maintenance. The monthly reports are detailed and timely. Highly recommend for serious investors!',
    rating: 5,
    location: 'Bahria Town, Islamabad',
  ),
  Testimonial(
    name: 'Zainab Ali',
    role: 'Landlord - Commercial Property',
    image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    text:
        'Excellent tenant screening and maintenance services. My properties are in great hands with Mirabella. They saved me thousands in potential damages by catching maintenance issues early.',
    rating: 5,
    location: 'F-7, Islamabad',
  ),
  Testimonial(
    name: 'Imran Malik',
    role: 'Property Developer',
    image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    text:
        'Professional team with deep market knowledge. Their property consulting helped me make informed investment decisions. Revenue increased significantly within the first year of partnership.',
    rating: 5,
    location: 'E-11, Islamabad',
  ),
  Testimonial(
    name: 'Sara Ahmed',
    role: 'First-time Property Owner',
    image: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=150',
    text:
        'As a first-time landlord, I was nervous about managing my property. Mirabella made everything so easy! They handle all the stress while I enjoy passive income. Couldn\'t be happier!',
    rating: 5,
    location: 'G-11, Islamabad',
  ),
];

/// Stats strip
const List<StatItem> statsData = [
  StatItem(
    number: '500+',
    label: 'Properties Managed',
    subtext: 'Across Islamabad & Rawalpindi',
  ),
  StatItem(
    number: '1000+',
    label: 'Happy Clients',
    subtext: 'Property Owners & Tenants',
  ),
  StatItem(
    number: '10+',
    label: 'Years Experience',
    subtext: 'In Real Estate Management',
  ),
  StatItem(
    number: '4.9/5',
    label: 'Client Rating',
    subtext: 'Based on 500+ Reviews',
  ),
];

/// Why choose us
const List<WhyUsItem> whyUsData = [
  WhyUsItem(
    title: 'Licensed & Insured',
    description:
        'Fully licensed real estate management company with comprehensive insurance coverage for your peace of mind.',
  ),
  WhyUsItem(
    title: '24/7 Availability',
    description:
        'Round-the-clock support for emergencies, tenant queries, and property owner concerns. We\'re always here.',
  ),
  WhyUsItem(
    title: 'Maximize ROI',
    description:
        'Strategic management and pricing optimization to maximize your rental income and property value.',
  ),
  WhyUsItem(
    title: 'Thorough Screening',
    description:
        'Comprehensive tenant screening including credit checks, employment verification, and reference checks.',
  ),
  WhyUsItem(
    title: 'Quick Response',
    description:
        'Average response time of under 2 hours for maintenance requests and emergency situations.',
  ),
  WhyUsItem(
    title: 'Transparent Reporting',
    description:
        'Detailed monthly financial reports and property updates through our online portal.',
  ),
  WhyUsItem(
    title: 'Market Expertise',
    description:
        'Deep understanding of local real estate market trends and competitive rental rates.',
  ),
  WhyUsItem(
    title: 'Customer First',
    description:
        'Dedicated account managers and personalized service tailored to your specific needs.',
  ),
];

/// Process steps
const List<ProcessStepItem> processData = [
  ProcessStepItem(
    step: '01',
    title: 'Initial Consultation',
    description:
        'We meet to understand your property, goals, and management needs.',
  ),
  ProcessStepItem(
    step: '02',
    title: 'Property Assessment',
    description:
        'Comprehensive evaluation of your property condition and market value.',
  ),
  ProcessStepItem(
    step: '03',
    title: 'Agreement & Onboarding',
    description:
        'Sign management agreement and set up your property in our system.',
  ),
  ProcessStepItem(
    step: '04',
    title: 'Marketing & Tenant Placement',
    description:
        'Professional listing, showings, screening, and lease signing.',
  ),
  ProcessStepItem(
    step: '05',
    title: 'Ongoing Management',
    description:
        'Regular maintenance, rent collection, and property oversight.',
  ),
  ProcessStepItem(
    step: '06',
    title: 'Regular Reporting',
    description: 'Monthly financial statements and property condition updates.',
  ),
];

/// FAQs
const List<FAQItem> faqsData = [
  FAQItem(
    question: 'What are your management fees?',
    answer:
        'Our management fees are competitive and transparent, typically ranging from 8-10% of monthly rent collected. We offer customized packages based on property type and services required. Contact us for a detailed quote.',
  ),
  FAQItem(
    question: 'How do you screen tenants?',
    answer:
        'We conduct comprehensive screening including credit checks, employment verification, previous landlord references, criminal background checks, and income verification. Only qualified tenants who meet our strict criteria are approved.',
  ),
  FAQItem(
    question: 'What areas do you serve?',
    answer:
        'We primarily serve Islamabad and Rawalpindi, including DHA, Bahria Town, E-11, F-7, G-13, and surrounding areas. Contact us to confirm if we serve your specific location.',
  ),
  FAQItem(
    question: 'How quickly can you fill a vacancy?',
    answer:
        'Our average vacancy period is 15-20 days due to our aggressive marketing strategy and extensive tenant network. Well-priced properties in good condition typically rent faster.',
  ),
  FAQItem(
    question: 'Do you handle maintenance and repairs?',
    answer:
        'Yes, we coordinate all maintenance and repairs using our network of trusted, licensed contractors. Emergency repairs are handled 24/7, and routine maintenance is scheduled efficiently.',
  ),
  FAQItem(
    question: 'How do I receive my rental income?',
    answer:
        'Rent is collected from tenants and disbursed to property owners by the 5th of each month via bank transfer, along with a detailed financial statement.',
  ),
  FAQItem(
    question: 'Can I terminate the management agreement?',
    answer:
        'Yes, our agreements include flexible termination clauses. Typically, 30-60 days notice is required, depending on the agreement terms.',
  ),
  FAQItem(
    question: 'What reports will I receive?',
    answer:
        'You\'ll receive monthly financial statements, annual tax documents, maintenance reports, property inspection reports, and can access real-time information through our owner portal.',
  ),
];

/// Pricing plans
const List<PricingPlan> pricingPlansData = [
  PricingPlan(
    name: 'Basic',
    price: '8%',
    period: 'of monthly rent',
    description: 'Perfect for single property owners',
    features: [
      'Tenant Screening & Placement',
      'Rent Collection',
      'Monthly Financial Reports',
      'Maintenance Coordination',
      '24/7 Emergency Support',
      'Online Owner Portal',
    ],
    popular: false,
  ),
  PricingPlan(
    name: 'Professional',
    price: '9%',
    period: 'of monthly rent',
    description: 'Ideal for multiple properties',
    features: [
      'Everything in Basic',
      'Priority Tenant Placement',
      'Bi-annual Property Inspections',
      'Legal Document Management',
      'Dedicated Account Manager',
      'Annual Market Analysis',
    ],
    popular: true,
  ),
  PricingPlan(
    name: 'Premium',
    price: '10%',
    period: 'of monthly rent',
    description: 'For serious investors',
    features: [
      'Everything in Professional',
      'Quarterly Property Inspections',
      'Investment Advisory',
      'Tax Document Preparation',
      'Portfolio Management',
      'Strategic Planning Sessions',
    ],
    popular: false,
  ),
];
