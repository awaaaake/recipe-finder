import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecipeDetailPage extends StatefulWidget {
  final Map recipe;

  const RecipeDetailPage({required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late List<bool> _ingredientChecklist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 재료 체크 상태 리스트를 초기화하고 모든 재료를 선택되지 않은 상태로 설정
    _ingredientChecklist =
        List<bool>.filled(widget.recipe['ingredients'].length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffACACAC),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 2.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.recipe['imageUrl'],
                    width: MediaQuery.of(context).size.width,
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                widget.recipe['menuName'],
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Main Ingredient: ${widget.recipe['mainIngredient']}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '조리 시간: ${widget.recipe['cookingTime']} 분',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/share.svg',
                    width: 23,
                    height: 23,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    'assets/save.svg',
                    width: 35,
                    height: 35,
                  ),
                ],
              ),
              // SizedBox(height: 10.0),
              // Text(
              //   '레시피 정보: ${recipe['recipeDescription']}',
              //   style: TextStyle(
              //     fontSize: 15.0,
              //   ),
              // ),
              SizedBox(height: 20.0),
              Divider(
                color: Colors.grey,
                height: 2.0,
              ),
              SizedBox(height: 20.0),
              Text(
                '재료',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.recipe['ingredients'].length,
                  (index) => Row(
                    children: [
                      Checkbox(
                        // checkColor: Colors.white,
                        // fillColor: MaterialStatePropertyAll(Color(0xffFFB01D)),
                        activeColor: Color(0xff242760),
                        value: _ingredientChecklist[index],
                        onChanged: (value) {
                          setState(() {
                            _ingredientChecklist[index] = value!;
                          });
                        },
                      ),
                      Text(
                        '${widget.recipe['ingredients'][index]}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Divider(
                color: Colors.grey,
                height: 2.0,
              ),
              SizedBox(height: 20.0),
              Text(
                '조리 방법',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  widget.recipe['recipeDescription'].length,
                  (index) => Text(
                    '${index + 1}. ${widget.recipe['recipeDescription'][index]}',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
