# Seed data for Vocare Courses
# Run with: bin/rails db:seed

# Admin user (only in development)
admin = AdminUser.find_or_create_by!(email: "admin@vocare.dk") do |user|
  user.password = "password123"
  user.name = "Vocare Admin"
end
puts "Admin user: admin@vocare.dk / password123"

# Course
course = Course.find_or_create_by!(slug: "vocare-salgskursus") do |c|
  c.title = "Vocare Salgskursus"
  c.description = "En masterclass i B2B-telefonsalg. 12 års erfaring destilleret ned til 8 kapitler. " \
                  "Lær alt fra de første 10 sekunder til closing og pipeline management."
  c.position = 0
  c.published = true
end

# Sections (chapters) from course text
sections_data = [
  {
    title: "Introduktion",
    slug: "introduktion",
    description: "12 års erfaring med salg. Hvorfor autenticitet slår teknik. Fake it till you make it.",
    lessons: [
      { title: "Velkommen til kurset", slug: "velkommen", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-intro" },
      { title: "Om Christopher og Vocare", slug: "om-christopher", content_type: "text",
        body: "Christopher har 12 års erfaring med B2B og B2C salg. Han har haft Statsministeriet, ministerier og C25-virksomheder som kunder." }
    ],
    quiz_questions: [
      { question: "Hvad mener Christopher er vigtigere end salgsteknik?", answer: "Autenticitet og ægthed. Hvordan du gør det er vigtigere end hvad du gør. Man skal brænde for produktet og tro på det." },
      { question: "Hvad anbefaler Christopher at gøre på dårlige dage?", answer: "Fake it till you make it. Gå en tur, tænk på noget andet i fem minutter, og prøv igen. Man kan bilde sin hjerne næsten hvad som helst ind." }
    ]
  },
  {
    title: "Fundamentet: Hvad er godt salg?",
    slug: "fundamentet",
    description: "Hvorfor 70% stopper efter tre måneder. Værdien af pres og fejl. Praktiker vs. strateg.",
    lessons: [
      { title: "Hvorfor de fleste giver op", slug: "hvorfor-giver-op", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap1" },
      { title: "Praktiker vs. strateg", slug: "praktiker-vs-strateg", content_type: "text",
        body: "Ring til 100 potentielle kunder i stedet for at bruge måneder på markedsanalyser. Den ydmyge og nysgerrige tilgang åbner døre." }
    ],
    quiz_questions: [
      { question: "Hvorfor mener Christopher det er sundt at fejle i salg?", answer: "Fordi det er sundt at være presset. Når hjernen er i overgear, lærer man hurtigst og mest om sig selv. De første par måneder i et svært salgsjob kan være skelsættende." },
      { question: "Hvad er forskellen på en praktiker og en strateg ifølge kurset?", answer: "En praktiker ringer til 100 kunder og starter dialogen med det samme. En strateg planlægger, køber konsulenter og laver markedsanalyser. Christopher foretrækker den praktiske tilgang." }
    ]
  },
  {
    title: "ICP + Skarpe Budskaber",
    slug: "icp-skarpe-budskaber",
    description: "Find din ideelle kundeprofil. Formuler budskaber der skaber dialog i stedet for 'okay, tillykke'.",
    lessons: [
      { title: "Hvad er en ICP?", slug: "hvad-er-icp", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap2" },
      { title: "Budskaber der virker", slug: "budskaber-der-virker", content_type: "text",
        body: "Dine budskaber skal handle om dem, ikke dig. Stil hv-spørgsmål der skaber dialog. Brug kunstpauser." },
      { title: "Eksempler på skarpe budskaber", slug: "eksempler-budskaber", content_type: "audio" }
    ],
    quiz_questions: [
      { question: "Hvad er en ICP, og hvorfor er den vigtig?", answer: "ICP er Ideal Customer Profile - den perfekte kunde. Det er de 20-30% bedste kunder, ikke gennemsnittet. Man skal starte med de lavthængende frugter og gøre det nemt for sig selv." },
      { question: "Hvad er 'okay, tillykke'-testen?", answer: "Hvis nogen kan svare 'okay, tillykke' til det du siger, har du for meget fokus på dig selv. Dine budskaber skal skabe dialog, ikke bare informere. Brug hv-spørgsmål efter din præsentation." }
    ]
  },
  {
    title: "De Første 10 Sekunder",
    slug: "de-foerste-10-sekunder",
    description: "Åbning af kaldet. Kontekst og ydmyghed. Håndtering af gatekeepere. LinkedIn research.",
    lessons: [
      { title: "Sådan åbner du kaldet", slug: "aabning-af-kald", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap3" },
      { title: "Gatekeeperen", slug: "gatekeeperen", content_type: "text",
        body: "Vær ydmyg men snu. Prøv at finde den rigtige person via LinkedIn først. Brug humor og charme." },
      { title: "Research og Social Selling", slug: "research-social-selling", content_type: "audio" }
    ],
    quiz_questions: [
      { question: "Hvad er Christophers foretrukne måde at åbne et kald på?", answer: "Simpelt og småydmygt. For eksempel: 'Hej, du taler med Christopher fra Vocare - jeg håber ikke, at jeg forstyrrer dig i noget meget presserende?' Det er vigtigt at give kontekst og være respektfuld." },
      { question: "Hvordan håndterer man en gatekeeper?", answer: "Vær ydmyg men snu. Sig at du har ledt på LinkedIn men ikke kan finde den rigtige person. Hvis de beder dig sende en mail, brug humor: 'Jeg er virkelig dårlig til mails, det er også derfor jeg ringer.'" }
    ]
  },
  {
    title: "Behovsafdækning",
    slug: "behovsafdaekning",
    description: "Hv-spørgsmål der skaber dialog. Aktiv lytning. Find kundens smertepunkter.",
    lessons: [
      { title: "Kunsten at stille spørgsmål", slug: "kunsten-at-spoerge", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap4" },
      { title: "Brug deres egne ord", slug: "brug-deres-ord", content_type: "text",
        body: "Saml ammunition fra samtalen. Brug kundens egne ord til at argumentere for produktet. Det er svært at tale imod sine egne ord." }
    ],
    quiz_questions: [
      { question: "Hvorfor er hv-spørgsmål bedre end ja/nej-spørgsmål i salg?", answer: "Hv-spørgsmål er dialogskabende og får kunden i tale. Ja/nej-spørgsmål lukker samtalen ned. Et enkelt godt hv-spørgsmål kan være nok til at starte en hel dialog." },
      { question: "Hvad er 'opsamlende luk-metoden'?", answer: "Man bruger kundens egne ord mod dem selv: 'Som du selv nævnte, var en af jeres største udfordringer dette... Og hvis vi kunne løse det...' Det er svært at tale imod sine egne ord." }
    ]
  },
  {
    title: "Pitch og Værdiskabelse",
    slug: "pitch-og-vaerdiskabelse",
    description: "EFU-modellen: Egenskaber, Fordele, Udbytte. Social proof. Kort og skarp pitch.",
    lessons: [
      { title: "EFU-modellen", slug: "efu-modellen", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap5" },
      { title: "Social Proof i B2B", slug: "social-proof", content_type: "text",
        body: "Folk i B2B er bange for at være forsøgskaniner. Fortæl dem om andre i deres branche med samme problemstilling og hvilke resultater de har fået." }
    ],
    quiz_questions: [
      { question: "Forklar EFU-modellen med et eksempel.", answer: "EFU: Egenskaber (features), Fordele (benefits), Udbytte (outcomes). Et CRM-system: Egenskab = samler data ét sted. Fordel = overblik og sparet tid. Udbytte = lukke flere salg og tjene flere penge. Udbytte er det vigtigste." },
      { question: "Hvorfor er Social Proof vigtigt i B2B-salg?", answer: "Folk i B2B er bange for at være forsøgskaniner. De vil ikke være de første der prøver noget nyt. Social proof fjerner risikoen og gør det nemmere at sige ja." }
    ]
  },
  {
    title: "Indvendingsbehandling",
    slug: "indvendingsbehandling",
    description: "Tre-delt responsformel: bekræft, forstå, vend. Eksempler på tid, budget og manglende interesse.",
    lessons: [
      { title: "Sådan håndterer du indvendinger", slug: "haandter-indvendinger", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap6" },
      { title: "De mest almindelige indvendinger", slug: "almindelige-indvendinger", content_type: "text",
        body: "Tid, budget og manglende interesse. Bekræft deres synspunkt, forstå bekymringen, og vend samtalen." }
    ],
    quiz_questions: [
      { question: "Hvad er den grundlæggende struktur for at håndtere en indvending?", answer: "Tre dele: 1) Bekræft dem ('Ja, det forstår jeg dig i'), 2) Accepter deres synspunkt, 3) Vend med 'men...' og giv et nyt perspektiv. Det handler om at validere deres bekymring og så tilbyde en løsning." },
      { question: "Hvordan håndterer du indvendingen 'Vi har ikke tid'?", answer: "Bekræft at de er travle, men påpeg at de altid vil være travle. Foreslå at tage det første spadestik nu, så de er klar når tiden er der, i stedet for at starte forfra senere." }
    ]
  },
  {
    title: "Closing + Pipeline",
    slug: "closing-pipeline",
    description: "A/B-lukket (alternativt luk). Antagende luk. Opfølgning. 'Har vi opgivet dette?'",
    lessons: [
      { title: "Lukkemetoder der virker", slug: "lukkemetoder", content_type: "video", video_url: "https://player.vimeo.com/video/placeholder-kap7" },
      { title: "Opfølgning og pipeline", slug: "opfoelgning-pipeline", content_type: "text",
        body: "Send den opsummerende mail med det samme. 'Har vi opgivet dette?' er det bedste trick til døde samtaler." },
      { title: "Fra median til den bedste", slug: "median-til-bedste", content_type: "audio" }
    ],
    quiz_questions: [
      { question: "Hvad er A/B-lukket, og giv et eksempel?", answer: "A/B-lukket (alternativt luk) giver kunden valget mellem ja eller ja, aldrig ja eller nej. Eksempel: 'Hvad passer dig bedst, den 16. eller den 19. april?' eller 'Skal vi starte med en bruger eller alle fem?'" },
      { question: "Hvad er tricket 'Har vi opgivet dette?' og hvornår bruger man det?", answer: "Når en samtale er gået død, vent 1-2 uger og skriv 'Har vi opgivet dette?' Det virker fordi beslutningstagere har et ego og ikke vil være typen der opgiver. De begynder at forsvare sig selv i stedet for at afvise." }
    ]
  }
]

sections_data.each_with_index do |section_data, index|
  section = Section.find_or_create_by!(course: course, slug: section_data[:slug]) do |s|
    s.title = section_data[:title]
    s.description = section_data[:description]
    s.position = index + 1
  end

  section_data[:lessons].each_with_index do |lesson_data, lesson_index|
    Lesson.find_or_create_by!(section: section, slug: lesson_data[:slug]) do |l|
      l.title = lesson_data[:title]
      l.content_type = lesson_data[:content_type]
      l.body = lesson_data[:body]
      l.video_url = lesson_data[:video_url]
      l.position = lesson_index + 1
      l.duration_seconds = lesson_data[:content_type] == "video" ? 600 : (lesson_data[:content_type] == "audio" ? 300 : nil)
    end
  end

  quiz = Quiz.find_or_create_by!(quizzable: section) do |q|
    q.title = "Quiz: #{section_data[:title]}"
    q.passing_score = 70
  end

  section_data[:quiz_questions].each_with_index do |qq_data, qq_index|
    QuizQuestion.find_or_create_by!(quiz: quiz, position: qq_index + 1) do |qq|
      qq.question_text = qq_data[:question]
      qq.expected_answer = qq_data[:answer]
    end
  end
end

# Final course quiz
final_quiz = Quiz.find_or_create_by!(quizzable: course) do |q|
  q.title = "Afsluttende Quiz: Vocare Salgskursus"
  q.description = "En samlet quiz der dækker alle 8 kapitler. Du skal bestå denne for at fuldføre kurset."
  q.passing_score = 70
end

final_questions = [
  { question: "Hvad er vigtigere end salgsteknik ifølge kurset?", answer: "Autenticitet. Hvordan du gør det er vigtigere end hvad du gør. Hvis du brænder for produktet og tror på det, slår det alle salgsteknikker." },
  { question: "Hvad er en ICP og hvorfor er den vigtig i B2B-salg?", answer: "Ideal Customer Profile - de 20-30% bedste kunder. Man skal starte med lavthængende frugter og fokusere på de kunder der får mest værdi." },
  { question: "Beskriv den ideelle åbning af et kald ifølge Christopher.", answer: "Simpel og ydmyg. Præsenter dig, giv kontekst, og spørg om det passer. F.eks. 'Hej, du taler med X fra Y - jeg håber ikke jeg forstyrrer?' Vis respekt for deres tid." },
  { question: "Hvad er EFU-modellen?", answer: "Egenskaber, Fordele, Udbytte. Gå fra kedelige features til konkrete fordele til det ultimative udbytte for kunden. Udbytte er det vigtigste - hvad får de ud af det?" },
  { question: "Forklar A/B-lukket og hvorfor det virker.", answer: "Alternativt luk: giv valget mellem to ja'er, aldrig ja/nej. F.eks. 'Hvad passer bedst, den 16. eller den 19.?' Det virker fordi kunden aldrig får mulighed for at sige nej." }
]

final_questions.each_with_index do |fq_data, fq_index|
  QuizQuestion.find_or_create_by!(quiz: final_quiz, position: fq_index + 1) do |qq|
    qq.question_text = fq_data[:question]
    qq.expected_answer = fq_data[:answer]
  end
end

# Sample token for testing
Token.find_or_create_by!(code: "VOCARE-TEST-0001") do |t|
  t.created_by = admin
  t.label = "Test token"
end

puts "Seeded: 1 course, #{Section.count} sections, #{Lesson.count} lessons, #{Quiz.count} quizzes, #{QuizQuestion.count} questions, 1 test token"
