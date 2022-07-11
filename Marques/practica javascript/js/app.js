(function(){
    const listElements = document.querySelectorAll('.menu_item--show');
    const List = document.querySelector('.menu_links');
    const menu = document.querySelector('.menu_desplegable');

    const addClick = ()=>{
        listElements.forEach(element =>{
            element.addEventListener('click', ()=>{

                let subMenu = element.children[1];
                let height = 0;
                element.classList.toggle('menu_item--active')

                if(subMenu.clientHeight === 0){
                    height = subMenu.scrollHeight;
                }

                subMenu.style.height = `${height}px`;
            });
        });
    }

    const BorrarHeight = ()=>{
        listElements.forEach(element=>{
            if(element.children[1].getAttribute('style')){
                element.children[1].removeAttribute('style');
                element.children[1].remove('menu_item--active');
            }
        });
    }
    

    window.addEventListener('resize', ()=>{
        if(window.innerWidth >800){
            BorrarHeight();
            if(List.classList.contains('menu_links--show')){
                List.classList.remove('menu_links--show')
            }
        }else{
            addClick();
        }
    });

    if(window.innerWidth <= 800){

    }else{
        addClick();
    }

    menu.addEventListener('click', ()=>List.classList.toggle('menu_links--show'));
})();

const url = 'https://jsonplaceholder.typicode.com/comments'

fetch(url)
    .then(response => response.json())
    .then(data => mostrarData(data))
const mostrarData = (data) => {
    console.log(data)
    let cuerpo = ''
    for(let i = 0; i < 9; i++){

        cuerpo += `<div class="tarjeta">
        <img src="http://placeimg.com/640/480/${data[i].id}" alt="" class="imagen">
        <h2><b>${data[i].name}</b></h2>
        <p><b>${data[i].body}</b></p>
        <p class="dreta">ID: ${data[i].id}</p>
        </div>`

    }

    document.getElementById('contenidor').innerHTML = cuerpo
}