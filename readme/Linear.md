
***Линейные алгоритмы классификации***  


Рассматривается задача классификации с двумя классами **Y={-1,+1}**. Модель алгоритма - параметрическое отображение ***a(x,w) = sign f(x, w)***  , где ***w - вектор параметров***, а ***f(x, w)*** - *дискриминантная функция*. 

Если её значение **> 0**, объект относится к классу **+1**, иначе **-1**. Уравнение ***f(x, w) = 0*** описывает разделяющую поверхность. 

![](http://latex.codecogs.com/svg.latex?M_i%28w%29%20%3D%20y_if%28x_i%2Cw%29) - *отступ* объекта ![](http://latex.codecogs.com/svg.latex?%5Cinline%20x_i) относительно классификатора. Если отступ отрицательный - алгоритм ошибся в классификации на объекте. Больше отступ - правильнее и надёжнее классификация объекта ![](http://latex.codecogs.com/svg.latex?%5Cinline%20x_i).  


![](http://latex.codecogs.com/svg.latex?%5Cinline%20%5Calpha%20%28M_i%28w%29%29) - *функция потерь*, а функция отступа - монотонно невозрастающая, мажорирующая пороговую ф-ю потерь : ![](http://latex.codecogs.com/svg.latex?%5Cinline%20%5BM%3C0%5D%5Cleqslant%20%5Calpha%20%28M%29). Тогда минимизация суммарных потерь - это метод минимизации числа ошибок на выборке: 

![](http://latex.codecogs.com/svg.latex?Q%28w%2CX%5El%29%20%3D%20%5Csum_%7Bi%3D1%7D%5E%7Bl%7D%5BM_i%28w%29%20%3C0%5D%20%5Cleqslant%20%5Coverset%7B-%7D%7BQ%7D%28w%2CX%5El%29%20%3D%20%5Csum_%7Bi%3D1%7D%5El%20%5Calpha%28M_i%28w%29%29%20%5Crightarrow%20%5Cunderset%7Bw%7D%7B%5Cmin%7D) 


Если дискриминантная функция - ![](http://latex.codecogs.com/svg.latex?%5Cinline%20%5Cleft%20%5Clangle%20x%2Cw%20%5Cright%20%5Crangle%2C%20w%5Cin%20%5Cmathbb%7BR%7D%5En), получим ***линейный классификатор***:  ![](http://latex.codecogs.com/svg.latex?a%28x%2Cw%29%20%3D%20%5Cmathrm%7Bsign%7D%28%5Cleft%20%5Clangle%20w%2Cx%20%5Cright%20%5Crangle%20-%20w_0%29%20%3D%20%5Cmathrm%7Bsign%7D%28%5Csum_%7Bj%3D1%7D%5Enw_jf_j%28x%29-w_0%29)

***Стохастический градиент***  

Необходимо найти вектор параметров ![](http://latex.codecogs.com/svg.latex?w%20%5Cin%20%5Cmathbb%7BR%7D%5En), где достигается минимум эмпирического риска.

Веса _w_  подбираются в цикле, на каждом шаге веса сдвигаются в направлении антиградиента  
![](http://latex.codecogs.com/svg.latex?Q%27%28w%29%20%3D%20%5CBigr%28%5Cfrac%7B%5Cpartial%20Q%28w%29%7D%7B%5Cpartial%20w_j%7D%5CBigr%29%5En_%7Bj%3D1%7D)  

Алгоритм получает обучающую выборку, темп обучения ![](http://latex.codecogs.com/svg.latex?%5Ceta) и параметр сглаживания ![](http://latex.codecogs.com/svg.latex?%5Clambda). Перед применением метода выборка подготавливается и нормируется:  

__Признаковое нормирование__

![](http://latex.codecogs.com/svg.latex?f_j%20%3D%20%5Cfrac%7Bf_j%20-%20m%7D%7B%5Csigma%7D)
, где _m_ – среднее арифмитическое значение признака _j_,
![](http://latex.codecogs.com/svg.latex?%5Csigma)
– среднеквадратическое отклонение.

__Подготовка__

Разделяющая поверхность
![](http://latex.codecogs.com/svg.latex?%5Clangle%20w%2C%20x%20%5Crangle%20%3D%200).

У нас объект имеет всего два признака.
![](http://latex.codecogs.com/svg.latex?w_1x_1%20&plus;%20w_2x_2%20%3D%200).
У разделяющей прямой нет св. коэфф-та, добавим фиктивный параметр *=-1* :
![](http://latex.codecogs.com/svg.latex?w_1x_1%20&plus;%20w_2x_2%20-%20w_3%20%3D%200).

***Подробный алгоритм SG***

1. Инициализация весов
![](http://latex.codecogs.com/svg.latex?w_j%2C%20j%3D1%2C...%2Cn).

2. Вычисление начального приближения
![](http://latex.codecogs.com/svg.latex?Q%20%3D%20%5Csum_%7Bi%20%3D%201%7D%5E%7B%5Cell%7D%20%5Cmathcal%7BL%7D%28%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i%29)

3. ***Пока  _Q_ не стабилизировано*** и в выборке присутствуют объекты с отрицательным **М**, ***повторять:***  
Условия выше иногда может быть не достаточно, алгоритм может остановиться, не получив необходимого результата, если два раза подряд выберет похожие элементы. Увеличим количество повторов выбора до десяти во избежание этого (меньшие значения были также проверены, и их было недостаточно).
 
4. Выбрать случайный элемент ![](http://latex.codecogs.com/svg.latex?x_i) 
5. Ошибка: ![](http://latex.codecogs.com/svg.latex?%5Cvarepsilon%20_i%20%3D%20%5Cmathcal%7BL%7D%28%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i%29)
6. Шаг градиентного спуска: ![](http://latex.codecogs.com/svg.latex?w%20%3D%20w%20-%20%5Ceta%20%5Cmathcal%7BL%7D%27%28%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i%29x_iy_i)
7. Оценка: ![](http://latex.codecogs.com/svg.latex?Q%20%3D%20%281%20-%20%5Clambda%29Q%20&plus;%20%5Clambda%20%5Cvarepsilon_i)

Линейные алгоритмы отличаются функцией потерь
![](http://latex.codecogs.com/svg.latex?%5Cmathcal%7BL%7D%28%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i%29)
, где
![](http://latex.codecogs.com/svg.latex?%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i)
– отступ.

***ADALINE***

Линейный алгоритм классификации, основан на методе стохастического градиента
![](http://latex.codecogs.com/svg.latex?%5Cmathcal%7BL%7D%28M%29%20%3D%20%28M%20-%201%29%5E2%20%3D%20%28%5Clangle%20w%2Cx_i%20%5Crangle%20y_i%20-%201%29%5E2). - квадратичная функция потерь.
Производная берётся по _w_ и равна ![](http://latex.codecogs.com/svg.latex?%5Cmathcal%7BL%7D%27%28M%29%20%3D%202%28%5Clangle%20w%2Cx_i%20%5Crangle%20-%20y_i%29x_i).  
Получили правило обновления весов на каждой итерации метода *SG* - **дельта - правило:**
![](http://latex.codecogs.com/svg.latex?w%20%3D%20w%20-%20%5Ceta%28%5Clangle%20w%2Cx_i%20%5Crangle%20-%20y_i%29x_i).

 [Программная реализация](https://zoncker.shinyapps.io/LinearMerged/) была выполнена с использованием библиотеки Shiny(Бесплатный хост - это нечто!) для построения графического интерфейса (пусть и ужасного), стохастический градиент был унифицирован для трёх классификаторов, также на выбор пользователю предлагается два набора параметров задания выборки, когда она линейно - разделима и когда - нет. [Исходник](../LinearMerged/app.R)
 
 Результаты работы:
 
 ![](pics/ada0.png) ![](pics/ada1.png)
 
 ***Персептрон Розенблатта***
 
 
Отличается от линейного адаптивного элемента _функцией потерь_ - тут она **кусочно-линейная** : 
![](http://latex.codecogs.com/svg.latex?%5Cmathcal%7BL%7D%28M%29%20%3D%20%28-M%29_&plus;)  
и правилом обновления весов - _правило Хэбба:_

если
![](http://latex.codecogs.com/svg.latex?%5Clangle%20w%2C%20x_i%20%5Crangle%20y_i%20%3C%200);  ![](http://latex.codecogs.com/svg.latex?w%20%3A%3D%20w&plus;%5Ceta%20x_iy_i).

 ![](pics/p0.png) ![](pics/p1.png)
 
 ***Логистическая регрессия*** - линейный алгоритм классификации, также являющийся оптимальным байесовским. Как и предыдущие, использует **SG** и также основан на довольно сильных вероятностных предположениях. Функция потерь - логистическая:
![](http://latex.codecogs.com/svg.latex?%5Cmathcal%7BL%7D%28M%29%20%3D%20%5Clog_2%281%20&plus;%20e%5E%7B-M%7D%29).

Правило обновления весов тоже другое, *логистическое*:
![](http://latex.codecogs.com/svg.latex?w%20%3A%3D%20w&plus;%5Ceta%20y_ix_i%5Csigma%28-%5Clangle%20w%2Cx_i%20%5Crangle%20y_i%29)
, а ![](http://latex.codecogs.com/svg.latex?%5Csigma%28-M_i%29%20%3D%20%5Cfrac%7B1%7D%7B1%20&plus;%20e%5E%7BM_i%7D%7D) - сигмоидная функция.

 ![](pics/lr0.png) ![](pics/lr1.png)
