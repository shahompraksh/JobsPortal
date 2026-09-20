/**
 * Elevate Workforce Solutions - Verified Production Jobs Dataset
 * Synchronized with Database Schema and Production Seed Data
 */
const ELEVATE_JOBS = [
    {
        id: 1,
        title: "Full-Stack Software Engineer",
        company: "Nepal IT Solution",
        category: "IT",
        location: "Kathmandu",
        salary: 40000,
        type: "Full-time",
        postedDate: "2 days ago",
        tags: ["Java", "JavaScript", "SQL", "REST API"],
        description: "Seeking a versatile Full-Stack Engineer with comprehensive knowledge of modern frontend web technologies and robust backend architectures. You will develop scalable microservices, optimize database queries, and contribute to Nepal's next-gen digital platforms.",
        requirements: [
            "1+ years experience in web application development",
            "Proficiency in Java, JavaScript, and MySQL",
            "Familiarity with Git and Agile development workflows",
            "Strong problem-solving mindset and communication skills"
        ]
    },
    {
        id: 2,
        title: "Senior UI/UX Designer",
        company: "Nepal IT Solution",
        category: "Design",
        location: "Pokhara",
        salary: 50000,
        type: "Full-time",
        postedDate: "3 days ago",
        tags: ["Figma", "Design Systems", "Prototyping", "User Research"],
        description: "Lead user interface and experience design across our enterprise portfolio. Conduct usability testing, create interactive wireframes in Figma, and build cohesive design systems that delight users.",
        requirements: [
            "Demonstrated portfolio of web/mobile interface designs",
            "Mastery of Figma, Adobe XD, and responsive design guidelines",
            "Experience creating user journey maps and wireframes",
            "Ability to work closely with engineering teams"
        ]
    },
    {
        id: 4,
        title: "Technical Support Representative",
        company: "Bhagya Laxmi International Pvt. Ltd.",
        category: "IT",
        location: "Kathmandu",
        salary: 45000,
        type: "Full-time",
        postedDate: "4 days ago",
        tags: ["Helpdesk", "IT Support", "Hardware", "Troubleshooting"],
        description: "Provide front-line technical helpdesk and IT support for enterprise clients. Diagnose software and hardware issues, configure network systems, and maintain customer satisfaction with timely issue resolution.",
        requirements: [
            "Diploma or Bachelor's in IT, Computer Science, or related field",
            "Hands-on experience troubleshooting Windows/macOS/Linux",
            "Excellent verbal and written communication in English & Nepali",
            "Customer-first attitude with prompt response habits"
        ]
    },
    {
        id: 5,
        title: "Graphic Designer & Content Creator",
        company: "Himalaya Media Solutions",
        category: "Design",
        location: "Lalitpur",
        salary: 42000,
        type: "Full-time",
        postedDate: "5 days ago",
        tags: ["Photoshop", "Illustrator", "Branding", "Social Media"],
        description: "Design high-impact visual graphics, digital marketing creatives, website UI banners, and brand identity materials using Adobe Illustrator, Photoshop, and Figma. Collaborate with our growth marketing team.",
        requirements: [
            "Strong graphic design portfolio showcasing digital & print assets",
            "Advanced skills in Adobe Illustrator, Photoshop, and InDesign",
            "Keen eye for modern typography, color harmony, and layout",
            "Ability to work under quick turnarounds and campaign deadlines"
        ]
    },
    {
        id: 6,
        title: "AI-Assisted Software Engineer",
        company: "Robotics Association of Nepal",
        category: "IT",
        location: "Pokhara",
        salary: 75000,
        type: "Full-time",
        postedDate: "1 day ago",
        tags: ["Python", "AI / ML", "Computer Vision", "APIs"],
        description: "Participate in intermediate software engineering projects leveraging modern AI tools, Python, REST APIs, and automated code review workflows. Deliver technical workshops and software modules for robotics initiatives.",
        requirements: [
            "Bachelor's in Computer Engineering, CS, or Electronics",
            "Proficiency in Python and machine learning frameworks (PyTorch/TF)",
            "Experience integrating LLMs and generative AI tools into software pipelines",
            "Passion for robotics and youth STEM education"
        ]
    },
    {
        id: 7,
        title: "Biomedical Engineer (Sales & Service)",
        company: "KNS Enterprises Pvt Ltd",
        category: "Healthcare",
        location: "Kathmandu",
        salary: 55000,
        type: "Full-time",
        postedDate: "6 days ago",
        tags: ["Biomedical", "Equipment Calibration", "Hospital Tech"],
        description: "Responsible for the installation, calibration, and preventive maintenance of advanced biomedical diagnostic equipment across hospitals in Nepal. Provide technical demonstrations and user training for healthcare personnel.",
        requirements: [
            "Degree in Biomedical Engineering or Electronics",
            "Knowledge of hospital clinical diagnostic equipment",
            "Willingness to travel to clinical sites in Bagmati Province",
            "Strong interpersonal and client-facing skills"
        ]
    },
    {
        id: 8,
        title: "Communication and Outreach Officer",
        company: "Youth Innovation Lab",
        category: "Marketing",
        location: "Lalitpur",
        salary: 60000,
        type: "Full-time",
        postedDate: "1 week ago",
        tags: ["Public Relations", "Digital Outreach", "Impact Stories"],
        description: "Lead communication campaigns, create content for digital outreach, draft impact stories, and coordinate public relations for disaster risk reduction and technological innovation initiatives across Nepal.",
        requirements: [
            "Bachelor's degree in Mass Communication, Journalism, or Marketing",
            "Proven copywriting and social media campaign experience",
            "Familiarity with developmental projects and youth engagement",
            "Fluent bilingual storytelling in Nepali and English"
        ]
    },
    {
        id: 9,
        title: "Data Integration Specialist (Bipad Portal)",
        company: "Sajag Nepal Project",
        category: "IT",
        location: "Kathmandu",
        salary: 85000,
        type: "Remote",
        postedDate: "Just now",
        tags: ["PostgreSQL", "PostGIS", "Python", "GIS Mapping"],
        description: "Design robust data pipelines for integrating geohazard datasets into the national Bipad disaster management portal. Work with PostgreSQL/PostGIS, Python backend services, and spatial data visualization tools.",
        requirements: [
            "3+ years data engineering or spatial GIS database experience",
            "Deep expertise in PostgreSQL, PostGIS, and Python data pipelines",
            "Familiarity with disaster risk assessment and open-source GIS",
            "Experience building cloud-native REST APIs"
        ]
    },
    {
        id: 10,
        title: "Admin and Finance Officer (AFO)",
        company: "SOSEC Nepal",
        category: "Finance",
        location: "Dailekh",
        salary: 50000,
        type: "Full-time",
        postedDate: "4 days ago",
        tags: ["Accounting", "Auditing", "Financial Reporting", "Compliance"],
        description: "Manage project accounting, prepare financial statements, coordinate with statutory auditors, and ensure strict compliance with institutional and donor procurement standards across regional offices.",
        requirements: [
            "BBA/BBS or Master's in Accounting or Finance",
            "Knowledge of Nepal tax laws, VAT, and NGO accounting rules",
            "Proficiency in Tally, Excel, and cloud financial ERPs",
            "Strong ethical integrity and organizational precision"
        ]
    },
    {
        id: 11,
        title: "Sales Executive Officer",
        company: "NIP Holdings Pvt Ltd",
        category: "Marketing",
        location: "Kathmandu",
        salary: 38000,
        type: "Full-time",
        postedDate: "5 days ago",
        tags: ["B2B Sales", "Client Pitching", "Lead Generation"],
        description: "Drive B2B sales growth, manage corporate client accounts, conduct product pitches, and hit monthly sales quotas in FMCG and hospitality sectors throughout Nepal.",
        requirements: [
            "Bachelor's degree in Business Administration or Marketing",
            "Proven track record in corporate field sales or retail distribution",
            "Negotiation and client relationship management strengths",
            "Valid driving license and two-wheeler preferred"
        ]
    },
    {
        id: 12,
        title: "Project Coordinator",
        company: "National Federation of the Disabled Nepal",
        category: "Operations",
        location: "Kathmandu",
        salary: 70000,
        type: "Full-time",
        postedDate: "1 week ago",
        tags: ["Advocacy", "Project Coordination", "Community Outreach"],
        description: "Coordinate advocacy projects, organize capacity development workshops, collaborate with local municipalities, and submit monthly monitoring progress reports to advance inclusive community welfare.",
        requirements: [
            "Master's degree in Social Work, Sociology, or Project Management",
            "Experience working with disability rights and community programs",
            "High proficiency in donor report writing and budgeting",
            "Empathetic, inclusive leadership approach"
        ]
    },
    {
        id: 13,
        title: "Client Relations Officer",
        company: "JobsNepal Direct Recruitment",
        category: "Marketing",
        location: "Kathmandu",
        salary: 35000,
        type: "Full-time",
        postedDate: "3 days ago",
        tags: ["Recruitment", "Client Relations", "HR Coordination"],
        description: "Coordinate with hiring partners and candidates, schedule interviews, screen resumes, and facilitate smooth onboarding processes for job seekers.",
        requirements: [
            "Bachelor's degree in HR, Management, or Communications",
            "Excellent phone and email communication etiquette",
            "Organizational skill to manage multiple candidate pipelines",
            "Energetic personality with enthusiasm for talent matching"
        ]
    },
    {
        id: 14,
        title: "Emergency Food Security & Livelihoods Officer",
        company: "Oxfam in Nepal",
        category: "Operations",
        location: "Birgunj",
        salary: 68000,
        type: "Full-time",
        postedDate: "2 weeks ago",
        tags: ["Humanitarian", "Food Security", "Livelihoods", "Field Work"],
        description: "Implement field-level cash transfer programming, vulnerable household assessments, market monitoring, and emergency response distributions.",
        requirements: [
            "Bachelor's or Master's in Agriculture, Economics, or Social Science",
            "Demonstrated field experience in humanitarian response programs",
            "Familiarity with Madhesh Province local dynamics and language",
            "Commitment to humanitarian core values and accountability"
        ]
    },
    {
        id: 15,
        title: "Sustainable Infrastructure Specialist",
        company: "WWF Nepal",
        category: "Engineering",
        location: "Kathmandu",
        salary: 95000,
        type: "Full-time",
        postedDate: "1 day ago",
        tags: ["Civil Engineering", "EIA", "Green Infrastructure"],
        description: "Advise on green infrastructure development, environmental impact assessments (EIA), and ecological corridors to align national infrastructure projects with biodiversity preservation.",
        requirements: [
            "Master's in Civil/Environmental Engineering or Sustainable Infrastructure",
            "5+ years experience in environmental compliance & linear infrastructure",
            "Deep understanding of Government of Nepal environmental legislation",
            "Excellent analytical and policy stakeholder engagement skills"
        ]
    },
    {
        id: 16,
        title: "UI/UX Design Intern",
        company: "Software Company",
        category: "Design",
        location: "Kathmandu",
        salary: 60000,
        type: "Internship",
        postedDate: "3 days ago",
        tags: ["Figma", "UI Design", "App Prototyping"],
        description: "Hands-on UI/UX design internship working directly on mobile and web applications. Working hours 08:00 AM - 05:00 PM. Mentorship provided by senior design leads.",
        requirements: [
            "Current student or fresh graduate in Design or Computer Science",
            "Working knowledge of Figma components and auto-layout",
            "Enthusiasm to learn user testing and design critique processes",
            "Creative eye for clean, minimalist mobile experiences"
        ]
    },
    {
        id: 17,
        title: "Virtual Teachers for STEM & English",
        company: "TurnKey Development Group",
        category: "Education",
        location: "Kathmandu",
        salary: 45000,
        type: "Remote",
        postedDate: "4 days ago",
        tags: ["Online Teaching", "Mathematics", "Science", "English"],
        description: "Responsible for conducting interactive online classes in Mathematics, Science, and English for secondary level students across Nepal. Preparing comprehensive digital lesson plans, monitoring student engagement, and grading assessments.",
        requirements: [
            "Bachelor's degree in Education, Science, or relevant discipline",
            "Comfortable with Zoom/Google Meet digital classrooms and whiteboards",
            "Patient and encouraging pedagogical approach",
            "Stable high-speed internet and quiet home teaching environment"
        ]
    },
    {
        id: 18,
        title: "Operations Manager",
        company: "International Federation of Red Cross (IFRC)",
        category: "Operations",
        location: "Kathmandu",
        salary: 110000,
        type: "Full-time",
        postedDate: "5 days ago",
        tags: ["Operations", "Disaster Response", "Executive Leadership"],
        description: "Lead, coordinate, and oversee comprehensive humanitarian disaster relief operations, community resilience initiatives, and risk mitigation strategies across disaster-prone zones in Nepal. Liaise with government authorities and partners.",
        requirements: [
            "Master's in Humanitarian Affairs, Public Administration, or Business",
            "7+ years progressive operational leadership in international NGOs",
            "Proven crisis management, logistics, and resource allocation record",
            "Unwavering adherence to humanitarian principles"
        ]
    },
    {
        id: 19,
        title: "Marketing Manager / Sales Executive",
        company: "Diplomat Nepal Pvt. Ltd.",
        category: "Marketing",
        location: "Kathmandu",
        salary: 52000,
        type: "Full-time",
        postedDate: "6 days ago",
        tags: ["Brand Growth", "Corporate Sales", "B2B Outreach"],
        description: "Drive institutional and corporate sales outreach across Nepal, identify emerging market opportunities, manage promotional brand campaigns, negotiate commercial supply contracts, and oversee customer relationship management.",
        requirements: [
            "Bachelor's or Master's in Marketing or Business Administration",
            "3+ years sales management experience with corporate clients",
            "Strong deal negotiation and contract finalization skills",
            "Strategic mindset with data-driven sales forecasting"
        ]
    },
    {
        id: 20,
        title: "Research, MEL Coordinator",
        company: "FAIRMED Foundation Nepal",
        category: "Healthcare",
        location: "Lalitpur",
        salary: 80000,
        type: "Full-time",
        postedDate: "1 week ago",
        tags: ["Public Health", "MEL", "Statistical Analysis", "Surveys"],
        description: "Design, manage, and execute systematic Monitoring, Evaluation, and Learning (MEL) frameworks for maternal/child health programs. Develop quantitative survey instruments, conduct statistical analyses, and draft donor impact reports.",
        requirements: [
            "Master's in Public Health, Statistics, or Development Studies",
            "Proficiency in SPSS, R, Stata, or KoboToolbox",
            "Demonstrated experience in health sector evaluations",
            "Strong publication and technical reporting portfolio"
        ]
    },
    {
        id: 21,
        title: "Part-Time Bookkeeper - Remote",
        company: "Andmine",
        category: "Finance",
        location: "Remote",
        salary: 35000,
        type: "Part-time",
        postedDate: "2 days ago",
        tags: ["Xero", "QuickBooks", "Bank Reconciliation", "Bookkeeping"],
        description: "Manage day-to-day accounts payable and receivable, perform regular bank reconciliations, prepare accurate invoicing, and generate monthly profit/loss reports using cloud accounting tools.",
        requirements: [
            "BBA/BBS with accounting specialization",
            "Hands-on experience with Xero, QuickBooks, or similar cloud software",
            "Available 20 hours per week during business hours",
            "High attention to mathematical accuracy and detail"
        ]
    },
    {
        id: 22,
        title: "Associate at Law Firm",
        company: "Reputed Legal Consultancy",
        category: "Legal",
        location: "Kathmandu",
        salary: 48000,
        type: "Full-time",
        postedDate: "5 days ago",
        tags: ["Corporate Law", "Contracts", "Litigation", "Compliance"],
        description: "Conduct detailed legal research, draft commercial agreements and employment contracts, prepare litigation briefs, and represent corporate clients before regulatory authorities and tribunals in Nepal.",
        requirements: [
            "LL.B or LL.M with valid Nepal Bar Council license",
            "1-2 years experience in corporate drafting or civil litigation",
            "Thorough knowledge of Company Act and Labor Act of Nepal",
            "Sharp drafting precision in both Nepali and English"
        ]
    },
    {
        id: 23,
        title: "District Project Manager",
        company: "Action For Nepal",
        category: "Operations",
        location: "Taplejung",
        salary: 75000,
        type: "Full-time",
        postedDate: "1 week ago",
        tags: ["Rural Development", "Project Management", "Field Leadership"],
        description: "Direct district-level program operations, supervise field teams, oversee multi-sector community development initiatives, manage project budgets, and foster constructive partnerships with local governments in eastern Nepal.",
        requirements: [
            "Master's degree in Rural Development, Social Sciences, or Management",
            "4+ years experience managing district-level developmental programs",
            "Experience coordinating with rural municipalities and Ward offices",
            "Readiness for remote mountainous district residence"
        ]
    },
    {
        id: 24,
        title: "Project Administration Traineeship",
        company: "World Vision International Nepal",
        category: "Operations",
        location: "Lalitpur",
        salary: 28000,
        type: "Internship",
        postedDate: "3 days ago",
        tags: ["Traineeship", "Administration", "NGO Support"],
        description: "Fast-track professional traineeship program for fresh graduates. Hands-on learning in project coordination, community outreach, digital documentation, and humanitarian program administration.",
        requirements: [
            "Recent graduate (BBA, BA, or Social Work within last 12 months)",
            "Strong enthusiasm to develop a career in social development",
            "Good computer literacy (MS Word, Excel, PowerPoint)",
            "Dynamic team player with a willingness to learn"
        ]
    },
    {
        id: 25,
        title: "Client Relations & Order Processing Officer",
        company: "Kamal Rug",
        category: "Marketing",
        location: "Pokhara",
        salary: 40000,
        type: "Full-time",
        postedDate: "4 days ago",
        tags: ["Export Relations", "Order Tracking", "Customer Care"],
        description: "Oversee international and domestic client communications, coordinate custom handicraft order tracking, liaise with production workshops, and ensure high quality delivery and client satisfaction.",
        requirements: [
            "Bachelor's degree in any discipline",
            "Experience in handicraft export, hospitality, or customer service",
            "Fluent English communication skills (written and spoken)",
            "High dependability and professional work ethic"
        ]
    }
];

// Provide in global scope
window.ELEVATE_JOBS = ELEVATE_JOBS;
