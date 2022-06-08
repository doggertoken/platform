<div class="bark">
    <div class="bark__profile">
        <img class="bark__picture" src="/img/logo.png" alt="" />
    </div>
    <div class="bark__content">
        <div class="bark__top">
            <div class="bark__left">
                <div class="bark__name">nathan.eth</div>
                <div class="bark__username">@nathanweb3</div>
                <div class="bark__time">· 10h</div>
            </div>
            <div class="bark__right">
                <div class="bark__more"></div>
            </div>
        </div>
        <div class="bark__text">Hey hey hey everybody</div>
        <div class="bark__bottom">
            <div class="bark__button">
                <img class="bark__icon" src="/img/comment.svg" alt="" /> 2
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/repost.svg" alt="" /> 3
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/like.svg" alt="" /> 8
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/share.svg" alt="" />
            </div>
        </div>
    </div>
</div>
<div class="bark">
    <div class="bark__profile">
        <img class="bark__picture" src="/img/logo.png" alt="" />
    </div>
    <div class="bark__content">
        <div class="bark__top">
            <div class="bark__left">
                <div class="bark__name">nathan.eth</div>
                <div class="bark__username">@nathanweb3</div>
                <div class="bark__time">· 10h</div>
            </div>
            <div class="bark__right">
                <div class="bark__more"></div>
            </div>
        </div>
        <div class="bark__text">My name is Carlos Matos and I am coming from New York City, New York! Let me tell you guys that I am SO EXCITED, I am SO HAPPY I am really so thrilled to be right now!</div>
        <div class="bark__bottom">
            <div class="bark__button">
                <img class="bark__icon" src="/img/comment.svg" alt="" /> 2
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/repost.svg" alt="" /> 3
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/like.svg" alt="" /> 8
            </div>
            <div class="bark__button">
                <img class="bark__icon" src="/img/share.svg" alt="" />
            </div>
        </div>
    </div>
</div>

<style>
    .bark {
        border-bottom: 1px solid var(--darkGray);
        display: flex;
        .bark__profile {
            width: 72px;
            .bark__picture {
                border-radius: 50%;
                height: 48px;
                margin: 12px 12px 0 12px;
                width: 48px;
            }
        }
        .bark__content {
            width: 100%;
            .bark__top {
                display: flex;
                justify-content: space-between;
                margin-top: 12px;
                .bark__left {
                    align-items: center;
                    column-gap: 8px;
                    display: flex;
                    .bark__name {
                        font-size: 16px;
                        font-weight: 700;
                    }
                }
                .bark__right {
                    .bark__more {}
                }
            }
            .bark__text {
                font-size: 17px;
                font-weight: 500;
                line-height: 1.4;
                margin-top: 4px;
            }
            .bark__bottom {
                align-items: center;
                column-gap: 100px;
                display: flex;
                justify-content: flex-start;
                padding: 12px 0 8px;
                .bark__button {
                    align-items: center;
                    column-gap: 12px;
                    display: flex;
                    .bark__icon {
                        height: 16px;
                        width: 16px;
                    }
                }
            }
        }
    }
</style>
