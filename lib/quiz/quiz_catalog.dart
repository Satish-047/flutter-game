import 'quiz_models.dart';

/// All quiz content: exactly **4** topics × **5** questions (20 in the bank).
/// One topic is chosen at random per session; all five questions come from that topic only.
final List<QuizTopic> kQuizTopicBank = [
  QuizTopic(
    id: 'animals',
    title: 'Animals',
    emoji: '🦁',
    description: 'Warm fur, feathers, and fun facts!',
    questions: [
      QuizQuestion.correctFirst(
        'animals_q1',
        'Which animal says “meow”?',
        'Cat',
        ['Dog', 'Cow', 'Duck'],
      ),
      QuizQuestion.correctFirst(
        'animals_q2',
        'How many legs does a spider usually have?',
        '8',
        ['6', '4', '10'],
      ),
      QuizQuestion.correctFirst(
        'animals_q3',
        'What sweet food do bees make?',
        'Honey',
        ['Milk', 'Maple syrup', 'Jam'],
      ),
      QuizQuestion.correctFirst(
        'animals_q4',
        'Which is the largest animal on Earth?',
        'Blue whale',
        ['Elephant', 'Giraffe', 'Polar bear'],
      ),
      QuizQuestion.correctFirst(
        'animals_q5',
        'Where do most emperor penguins live?',
        'Antarctica',
        ['Desert', 'Rainforest', 'Mountaintops'],
      ),
    ],
  ),
  QuizTopic(
    id: 'colors',
    title: 'Colors',
    emoji: '🎨',
    description: 'Rainbows and mixing!',
    questions: [
      QuizQuestion.correctFirst(
        'colors_q1',
        'What color do you get when you mix red and blue?',
        'Purple',
        ['Green', 'Orange', 'Brown'],
      ),
      QuizQuestion.correctFirst(
        'colors_q2',
        'On a sunny day the sky often looks…',
        'Blue',
        ['Red', 'Purple', 'Gray'],
      ),
      QuizQuestion.correctFirst(
        'colors_q3',
        'Healthy grass outside is usually…',
        'Green',
        ['Yellow', 'Pink', 'Black'],
      ),
      QuizQuestion.correctFirst(
        'colors_q4',
        'Fresh snow is most often seen as…',
        'White',
        ['Blue', 'Yellow', 'Green'],
      ),
      QuizQuestion.correctFirst(
        'colors_q5',
        'A ripe banana is commonly…',
        'Yellow',
        ['Blue', 'Purple', 'Red'],
      ),
    ],
  ),
  QuizTopic(
    id: 'shapes',
    title: 'Shapes',
    emoji: '📐',
    description: 'Corners, curves, and names!',
    questions: [
      QuizQuestion.correctFirst(
        'shapes_q1',
        'How many sides does a triangle have?',
        '3',
        ['4', '5', '6'],
      ),
      QuizQuestion.correctFirst(
        'shapes_q2',
        'A square has four sides that are all…',
        'Equal length',
        ['Different lengths', 'Curved only', 'Only two equal'],
      ),
      QuizQuestion.correctFirst(
        'shapes_q3',
        'A ball is shaped most like a…',
        'Sphere',
        ['Cube', 'Cylinder', 'Pyramid'],
      ),
      QuizQuestion.correctFirst(
        'shapes_q4',
        'How many corners does a rectangle have?',
        '4',
        ['3', '5', '8'],
      ),
      QuizQuestion.correctFirst(
        'shapes_q5',
        'Which shape has no corners?',
        'Circle',
        ['Square', 'Pentagon', 'Diamond'],
      ),
    ],
  ),
  QuizTopic(
    id: 'numbers',
    title: 'Numbers',
    emoji: '🔢',
    description: 'Counting and simple sums!',
    questions: [
      QuizQuestion.correctFirst(
        'numbers_q1',
        'What is 7 + 5?',
        '12',
        ['11', '13', '10'],
      ),
      QuizQuestion.correctFirst(
        'numbers_q2',
        'How many fingers on one hand?',
        '5',
        ['4', '10', '8'],
      ),
      QuizQuestion.correctFirst(
        'numbers_q3',
        'What whole number comes right after 19?',
        '20',
        ['21', '18', '22'],
      ),
      QuizQuestion.correctFirst(
        'numbers_q4',
        'Half of 10 is…',
        '5',
        ['2', '20', '10'],
      ),
      QuizQuestion.correctFirst(
        'numbers_q5',
        'Continue the pattern: 2, 4, 6, …',
        '8',
        ['7', '9', '10'],
      ),
    ],
  ),
];
